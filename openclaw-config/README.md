# OpenClaw Configuration Backup

This folder contains sanitized OpenClaw configuration files for backup purposes.

## Files

### openclaw.json
**Location:** `~/.openclaw/openclaw.json`  
**Purpose:** Main OpenClaw configuration file

**Contains:**
- Model providers and settings
- Channel configurations (Discord, iMessage)
- Workspace paths
- Agent defaults
- Tool configurations

**Secrets Removed:**
- Discord bot tokens
- API keys
- Authentication tokens

## Recovery

To restore:
1. Copy `openclaw.json` back to `~/.openclaw/`
2. Re-authenticate with `openclaw auth` to regenerate tokens
3. Verify workspace path matches your system

## Original Location

Full OpenClaw installation: `~/.openclaw/`

---
*Last backup: 2026-03-02*
