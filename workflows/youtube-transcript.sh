#!/bin/bash

# YouTube Transcript Script
# Usage: ./youtube-transcript.sh [URL] [OPTIONS]

set -e

# Base path for saved transcripts - always goes to Articles folder
BASE_PATH="/Users/jarvis/Mac-Mini-Obsidian-Vault/2. the-brain/3. resources/Articles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help message
show_help() {
    cat << EOF
YouTube Transcript Script

Usage:
  $0 "https://youtube.com/watch?v=VIDEO_ID"
  $0 --search "search query" [--limit N]

Options:
  --search QUERY    Search for videos matching query
  --limit N         Limit search results (default: 5)
  -h, --help        Show this help message

Examples:
  $0 "https://youtu.be/ABC123"
  $0 --search "Peter Thiel interview" --limit 10
EOF
}

# Parse arguments
SEARCH_MODE=false
SEARCH_QUERY=""
URL=""
LIMIT=5

while [[ $# -gt 0 ]]; do
    case $1 in
        --search)
            SEARCH_MODE=true
            SEARCH_QUERY="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            URL="$1"
            shift
            ;;
    esac
done

# Validate required arguments
if [[ "$SEARCH_MODE" == true && -z "$SEARCH_QUERY" ]]; then
    echo -e "${RED}Error: Search query required${NC}"
    show_help
    exit 1
fi

if [[ "$SEARCH_MODE" == false && -z "$URL" ]]; then
    echo -e "${RED}Error: URL required (or use --search)${NC}"
    show_help
    exit 1
fi

# Create Articles directory
mkdir -p "$BASE_PATH"

echo -e "${YELLOW}Saving transcripts to: $BASE_PATH${NC}"

# Function to clean up VTT subtitle text
process_vtt() {
    local file="$1"
    # Skip WEBVTT header, timestamps, CSS cues
    cat "$file" | \
        sed 's/^WEBVTT.*//' | \
        sed 's/^Kind:.*//' | \
        sed 's/^Language:.*//' | \
        sed '/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/d' | \
        sed 's/<[^>]*>//g' | \
        sed 's/^.*-->.*$//' | \
        awk '
            NF && !seen[$0]++ {
                if (buf) { print buf }
                buf = $0
            }
            END { if (buf) print buf }
        ' | \
        grep -v '^[[:space:]]*$'
}

# Function to format transcript with proper paragraphs
format_transcript() {
    local input="$1"
    local output_file="$2"
    
    # Process line by line
    local prev_line=""
    local first=1
    
    echo "$input" | while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines
        [[ -z "$line" ]] && continue
        
        # Skip common VTT cruft
        [[ "$line" =~ ^[[:space:]]*\[Music\][[:space:]]*$ ]] && continue
        [[ "$line" =~ ^[[:space:]]*Kind:\s* ]] && continue
        [[ "$line" =~ ^[[:space:]]*Language:\s* ]] && continue
        
        # If line starts with capital letter, it's likely a new sentence
        if [[ "$line" =~ ^[A-Z] ]]; then
            if [[ $first -eq 1 ]]; then
                printf "%s" "$line"
                first=0
            else
                printf "\n\n%s" "$line"
            fi
        else
            # continuation
            printf " %s" "$line"
        fi
    done
}

# Function to extract video info and transcript
process_video() {
    local video_url="$1"
    local video_id

    # Extract video ID
    if [[ "$video_url" =~ v=([a-zA-Z0-9_-]{11}) ]]; then
        video_id="${BASH_REMATCH[1]}"
    elif [[ "$video_url" =~ youtu\.be/([a-zA-Z0-9_-]{11}) ]]; then
        video_id="${BASH_REMATCH[1]}"
    else
        echo -e "${RED}Error: Could not extract video ID from URL${NC}"
        return 1
    fi

    echo -e "${YELLOW}Processing video: $video_id${NC}"

    # Get video metadata
    local title=$(yt-dlp --print title "$video_url" 2>/dev/null)
    local channel=$(yt-dlp --print channel "$video_url" 2>/dev/null)
    local upload_date=$(yt-dlp --print upload_date "$video_url" 2>/dev/null)
    local duration=$(yt-dlp --print duration "$video_url" 2>/dev/null)

    if [[ -z "$title" ]]; then
        echo -e "${RED}Error: Could not fetch video metadata${NC}"
        return 1
    fi

    # Format filename - just the title, no date prefix
    local safe_title=$(echo "$title" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//' | cut -c1-80)
    local filename="$safe_title.md"
    local filepath="$BASE_PATH/$filename"

    # Check for duplicate
    if [[ -f "$filepath" ]]; then
        echo -e "${YELLOW}Transcript already exists: $filename${NC}"
        return 0
    fi

    echo -e "${YELLOW}Fetching transcript for: $title${NC}"

    # Download subtitles
    local temp_dir=$(mktemp -d)
    yt-dlp --write-auto-sub --sub-langs en --skip-download --output "$temp_dir/%(title)s.%(ext)s" "$video_url" 2>/dev/null || true

    local subtitle_file=$(find "$temp_dir" -name "*.vtt" | head -1)
    local transcript_text=""

    if [[ -f "$subtitle_file" ]]; then
        # Process VTT to proper text
        local processed=$(process_vtt "$subtitle_file")
        # Format with proper paragraphs
        transcript_text=$(format_transcript "$processed")
    fi

    rm -rf "$temp_dir"

    # Format duration
    local duration_formatted="$(($duration / 60)):$(printf "%02d" $(($duration % 60)))"
    local formatted_date="${upload_date:0:4}-${upload_date:4:2}-${upload_date:6:2}"
    local transcribed_date=$(date '+%Y-%m-%d %H:%M')

    # Write markdown file
    cat > "$filepath" << EOF
---
captured: $(date '+%Y-%m-%d')
source_url: $video_url
category: transcript
---

# $title

**Channel:** $channel  
**URL:** $video_url  
**Published:** $formatted_date  
**Duration:** $duration_formatted  
**Transcribed:** $transcribed_date

---

## Transcript

$transcript_text
EOF

    echo -e "${GREEN}✓ Saved: $filename${NC}"
}

# Main execution
if [[ "$SEARCH_MODE" == true ]]; then
    echo -e "${YELLOW}Searching for: $SEARCH_QUERY (limit: $LIMIT)${NC}"

    # Use yt-dlp to search
    local video_urls=$(yt-dlp "ytsearch$LIMIT:$SEARCH_QUERY" --get-id --no-download 2>/dev/null)

    if [[ -z "$video_urls" ]]; then
        echo -e "${RED}Error: No videos found${NC}"
        exit 1
    fi

    local count=0
    while IFS= read -r video_id; do
        if [[ -n "$video_id" ]]; then
            count=$((count + 1))
            echo -e "\n${YELLOW}[$count/$LIMIT] Processing...${NC}"
            process_video "https://youtube.com/watch?v=$video_id"
        fi
    done <<< "$video_urls"

    echo -e "\n${GREEN}✓ Processed $count videos to: $BASE_PATH${NC}"
else
    process_video "$URL"
fi
