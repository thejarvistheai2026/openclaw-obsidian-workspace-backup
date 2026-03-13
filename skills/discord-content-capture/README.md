## Discord Content Capture Skill

### Quick Start

1. **Create Discord channel**: `Content Capture 2` (already done ✓)
2. **Invite AvaBot**: Grant permissions to read/send messages in that channel
3. **Start capturing**: Paste any URL in the channel

### How It Works

- AvaBot monitors `#Content Capture 2`
- Detects any URL in messages
- Calls defuddle API: `defuddle.md/[URL]`
- Extracts clean Markdown
- Adds YAML frontmatter (captured, source_url, title, author, type)
- Saves to: `2. the-brain/3. resources/Articles/[title].md`
- Replies in Discord with confirmation

### URL Types Supported

| Platform | Type | Notes |
|----------|------|-------|
| YouTube | `youtube` | Transcript via defuddle |
| Twitter/X | `twitter` | Thread via defuddle |
| Substack | `substack` | Article via defuddle |
| Blogs | `article` | Generic via defuddle |
| Any other | `article` | Fallback to defuddle |

### Testing

1. Join `#Content Capture 2` Discord channel
2. Paste any URL, e.g.:
   - `https://www.youtube.com/watch?v=...`
   - `https://twitter.com/...`
   - `https://someblog.com/article`
3. Wait for confirmation message from AvaBot
4. Check Obsidian vault: `2. the-brain/3. resources/Articles/`

### Troubleshooting

**AvaBot doesn't respond:**
- Check AvaBot has permissions in channel
- Verify channel name is exactly `Content Capture 2`
- Check `/tmp/openclaw/openclaw-YYYY-MM-DD.log` for errors

**File not saving:**
- Check output directory exists: `2. the-brain/3. resources/Articles/`
- Check write permissions

**defuddle API fails:**
- Check internet connection
- URL may be blocked or require auth
- Try different URL

### Files

- `skills/discord-content-capture/index.js` — Main handler
- `skills/discord-content-capture/config.json` — Configuration
- `skills/discord-content-capture/SKILL.md` — Documentation

### Next Steps

- [ ] Add AvaBot to `#Content Capture 2` channel
- [ ] Test with sample YouTube URL
- [ ] Test with sample Twitter URL
- [ ] Test with sample blog article
