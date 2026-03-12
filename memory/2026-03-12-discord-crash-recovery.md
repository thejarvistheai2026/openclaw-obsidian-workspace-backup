# Discord Gateway Crash Recovery - 2026-03-12

## What Happened

Attempted to configure Discord using `openclaw config set` commands:
```bash
openclaw config set channels.discord.token '"TOKEN"' --json
openclaw config set channels.discord.enabled true --json
```

This created config that Gateway rejected on restart with error:
```
channels.discord.groupPolicy: Invalid option: expected one of "open"|"disabled"|"allowlist"
```

## Root Cause

The CLI `config set` command auto-populated `groupPolicy: "allowlist"` (safe default), but the generated structure may have had syntax issues or validation errors that Gateway couldn't parse on reload.

## Recovery Steps (What Worked)

1. **Run doctor to diagnose:**
   ```bash
   openclaw doctor
   ```

2. **Auto-fix the config (CRITICAL):**
   ```bash
   openclaw doctor --fix
   ```
   This corrected the Discord block structure.

3. **Reinstall/restart Gateway:**
   ```bash
   openclaw gateway install
   openclaw gateway restart
   ```

4. **Verify:**
   ```bash
   openclaw gateway status
   openclaw channels status --probe
   ```

## Safer Method for Discord Config

**Instead of CLI commands:**

1. Stop Gateway first:
   ```bash
   openclaw gateway stop
   ```

2. **Manually edit** `~/.openclaw/openclaw.json` with valid structure:
   ```json
   "channels": {
     "discord": {
       "enabled": true,
       "token": "YOUR_TOKEN",
       "groupPolicy": "open",
       "streaming": "off"
     }
   }
   ```

3. Validate JSON:
   ```bash
   cat ~/.openclaw/openclaw.json | python3 -m json.tool > /dev/null && echo "Valid JSON"
   ```

4. Start Gateway:
   ```bash
   openclaw gateway start
   ```

## Security Note

**The Discord token was exposed in this incident.** Best practice:
- Reset token via Discord Developer Portal
- Update config with new token
- Never post tokens in chat logs

## Validation Checklist

Before any Gateway restart:
- [ ] Config is valid JSON: `python3 -m json.tool`
- [ ] `groupPolicy` is one of: `open`, `disabled`, `allowlist`
- [ ] If `allowlist`, include proper allowlist arrays
- [ ] Backup config before changes

## Files to Reference

- Full Discord docs: `/opt/homebrew/lib/node_modules/openclaw/docs/channels/discord.md`
- Config schema: `openclaw config validate` (if available)

---
**Last Updated:** 2026-03-12
**OpenClaw Version:** 2026.3.8
