# Discord Content Capture Skill

Captures URLs from Discord channel "Content Capture 2", processes via defuddle API, saves to Obsidian vault.

## Trigger

- Channel: `Content Capture 2`
- Auto-process: Any message containing URL

## Action

1. Extract URL from message
2. Detect type (YouTube, Twitter/X, or general article)
3. Call defuddle API: `curl defuddle.md/[URL]`
4. Format with YAML frontmatter
5. Save to: `2. the-brain/3. resources/Articles/[slug].md`
6. Reply in Discord with confirmation

## YAML Frontmatter Template

```yaml
---
captured: YYYY-MM-DD
source_url: [original URL]
title: [extracted from defuddle or page]
author: [extracted if available]
type: [youtube|twitter|article]
---
```

## Dependencies

- `curl` for defuddle API
- Discord channel permissions
- Write access to vault

## Testing

Paste any URL in #Content Capture 2 channel.
