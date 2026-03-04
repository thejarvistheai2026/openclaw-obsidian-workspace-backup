# MEMORY.md - Long-term Knowledge

## PARA Structure

```
Mac-Mini-Obsidian-Vault/
├── 1. openclaw/          ← Agent workspace (configs, memory, workflows)
├── 2. the-brain/         ← Knowledge base (projects, areas, resources, archive)
│   ├── 1. projects/
│   ├── 2. areas/
│   ├── 3. resources/     ← Saved articles, links, references
│   └── 4. archive/
├── 3. code/              ← Code projects (newsletter-system, skills, etc.)
├── 4. CRM/               ← People, contacts, relationships
└── .obsidian/            ← Obsidian config
```

## GitHub Backup System

| Source | Repo | URL |
|--------|------|-----|
| `1. openclaw/` | `openclaw-obsidian-workspace-backup` | https://github.com/thejarvistheai2026/openclaw-obsidian-workspace-backup |
| `2. the-brain/` | `PARA-Obsidian-vault-backup` | https://github.com/thejarvistheai2026/PARA-Obsidian-vault-backup |
| `4. CRM/` | `obsidian-crm` | https://github.com/thejarvistheai2026/obsidian-crm |
| `3. code/newsletter-system/` | `jarvis-newsletter-system` | https://github.com/thejarvistheai2026/jarvis-newsletter-system |

**Backup:** Daily at 23:00 via LaunchAgent → `1. openclaw/.scripts/daily-backup.sh`

## Newsletter System

**Location:** `3. code/newsletter-system/`
**Output:** `2. the-brain/3. resources/Newsletters/`
**Database:** `3. code/newsletter-system/data/state.db`
**Schedule:** Sundays + Thursdays

**Key paths (hardcoded):**
- `NEWSLETTERS_DIR` → `2. the-brain/3. resources/Newsletters`
- `DB_FILE` → `3. code/newsletter-system/data/state.db`

## Key Decisions (2026-03-02)

1. **No symlinks** — cause Obsidian Sync conflicts
2. **Separate repos** — recoverable pieces, not one giant repo
3. **Scripts use hardcoded paths** — numbered folders don't change
4. **Sanitized OpenClaw config** — tokens redacted in backups

## Backup System Updates (2026-03-04)

### Fixes Applied
- **Newsletter LaunchAgent path corrected** — was pointing to wrong directory (`openclaw/newsletter-system` ➜ `3. code/newsletter-system`)
- **Git identity configured** — All 4 repos now have proper user.name and user.email
- **Emergency documentation updated** — All outdated paths corrected
- **Working paths verified**:
  - Daily backup: `1. openclaw/.scripts/daily-backup.sh` ✓
  - LaunchAgent: `~/Library/LaunchAgents/ai.thejarvis.openclaw.daily-backup.plist` ✓
  - Newsletter: `~/Library/LaunchAgents/com.openclaw.newsletter.plist` ✓
  - Git repos: All 4 properly configured ✓

## Workflows

**YouTube Transcripts:** `1. openclaw/workflows/youtube-transcript.sh`
- **Location:** Always save to `2. the-brain/3. resources/Articles/`
- **Filename:** Video title only (no date prefix, no timestamp)
- **Format:** Single-column text with proper paragraph breaks
- **YAML frontmatter:** Include `captured: YYYY-MM-DD`, `source_url`, and `category: transcript`

## Obsidian Best Practices

**Plugins to install:**
1. Templater — templates
2. QuickAdd — quick capture
3. Dataview — queries
4. Calendar — daily notes nav

**Naming:** `YYYY-MM-DD - description-with-hyphens.md`

## Recovery

If vault is lost:
1. Clone all 4 repos above
2. Place in correct numbered folders
3. Update OpenClaw config workspace path
4. Run newsletter scripts to verify paths
