# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## Vault Paths (Critical)

**Articles / Captured Content:**
- **ALWAYS save to:** `2. the-brain/3. resources/Articles/`
- **Format:** `descriptive-title.md` (NO date prefix)
- **NOT** directly in `3. resources/` — must be in the `Articles/` subfolder
- The `captured:` field in YAML frontmatter tracks the date instead

---

## Web Development Defaults

**UI Framework:** ShadCN/UI (built on Tailwind + Radix)
- Install: `npx shadcn@latest init`
- Add components: `npx shadcn add [component]`
- Default base color: `neutral` or `slate` (ask if preference unclear)

**Styling:** Tailwind CSS — always use unless there's a specific reason not to

**Component Priority:**
1. ShadCN built-ins first (Button, Card, Dialog, etc.)
2. Custom ShadCN-style components second
3. Third-party only if necessary

**Why:** Consistency, accessibility out-of-the-box, easy to customize

### ShadCN CLI v4 Features (for agents)

**Design System Presets:**
- Use `--preset [code]` to scaffold with a custom design system
- Presets pack colors, fonts, radius, icons into one string
- Create presets at shadcn/create, preview live, then use the code

**Safe Operations:**
- `--dry-run` — preview what gets added without writing files
- `--diff` — check for updates before merging (great for updating primitives)
- `--view` — inspect registry payload before installing

**Project Scaffolding:**
- Templates: `shadcn init --template [next|vite|laravel|react-router|astro|tanstack]`
- Monorepo: `shadcn init --monorepo`
- Dark mode included (Next.js/Vite templates)
- Choose primitives: `--base radix` (default) or `--base base-ui`

**Agent Context:**
- Reference `shadcn/skills` for coding agent guidelines on component patterns
- Use `shadcn info` to get project context (framework, components, CSS vars)
- Use `shadcn docs [component]` to get component docs/examples from CLI

**Third-party Components:**
- Install from any registry: `shadcn add @owner/component`
- Examples: `@clerk/sign-in`, `@magicui/marquee`, `tailark/hero`

---

## Active Systems (2026-03-07)

### Discord Retrospective Capture
- **Bot:** the-observer#9526
- **Capture:** 24/7 continuous
- **Retros:** Sun/Thu @ 22:00
- **Output:** `memory/discord-retro/*.md`
- **Docs:** `discord-capture/README.md`
- **Start:** `cd discord-capture && node bot.js`

### Daily Status Report
- **Schedule:** Daily @ 08:00
- **Recipient:** +16138893035 (iMessage)
- **LaunchAgent:** `ai.thejarvis.openclaw.daily-status`
- **Logs:** `daily-status.log`, `daily-status.error`
- **Docs:** `.scripts/daily-status-report.md`

### Google Workspace (gws)
- **Tool:** `gws` (replaces gog)
- **Auth:** jarvistheai2026@gmail.com
- **Skills:** 38 in `skills/` directory
- **Docs:** `skills/gws/README.md`
- **Test:** `gws gmail +triage --max 5`

### Complete Schedule

| Time | Sun | Mon | Tue | Wed | Thu | Fri | Sat |
|------|-----|-----|-----|-----|-----|-----|-----|
| **08:00** | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status | 📊 Status |
| **09:00** | 📰 News | | | | 📰 News | | |
| **22:00** | 💬 Retro | | | | 💬 Retro | | |
| **23:00** | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup | 💾 Backup |

---

Add whatever helps you do your job. This is your cheat sheet.
