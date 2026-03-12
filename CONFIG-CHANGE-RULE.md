# CONFIG-CHANGE-RULE.md

**Rule:** Ask before changing OpenClaw config files or restarting services.

**Why:** Editing openclaw.json or restarting the gateway/running services can:
- Break the current session
- Disconnect from the control UI
- Cause the gateway to become unreachable

**Applies to:**
- Editing ~/.openclaw/openclaw.json
- Running `openclaw gateway restart`
- Running `openclaw gateway stop`
- Any service restart that could disrupt connectivity

**Procedure:**
1. Show proposed changes
2. Wait for confirmation
3. Implement
4. Verify connection is maintained

**Exception:** Only automatic if explicitly told "just do it" or clearly non-breaking (like adding skill configs that don't require restart).

**Violation:** 2026-03-11 - Ava edited openclaw.json and restarted gateway mid-conversation, causing disconnect.
