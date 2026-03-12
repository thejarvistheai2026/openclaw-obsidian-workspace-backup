# CONFIG-CHANGE-PROTOCOL.md

**Purpose:** Safe process for editing OpenClaw configuration files.

**Author:** Ava (2026-03-11)  
**Context:** Learned from multiple gateway restarts that disconnected sessions.

---

## The Rule

> **Never edit config files or restart services without explicit confirmation, unless the user says "just do it" or it's clearly non-breaking.**

---

## The Process (5 Steps)

### 1. PROPOSE — Show the Change

Present exactly what will be modified:
- **File:** Which file will change
- **Section:** What part of the config
- **Before/After:** Clear diff
- **Purpose:** What this enables

**Example:**
```
Adding iMessage channel config to ~/.openclaw/openclaw.json

Currently: No channels section
After: channels.imessage.enabled = true
         channels.imessage.dmPolicy = "pairing"
         channels.imessage.allowFrom = ["+1613..."]

Enables: You can text me from iMessage
```

### 2. VALIDATE — Check Before Applying

- [ ] Run JSON syntax check (python -m json.tool)
- [ ] Run `openclaw doctor` if available
- [ ] Identify any validation warnings
- [ ] Verify required dependencies are installed

**If validation fails:** Stop, report errors, don't proceed.

### 3. DOCUMENT — Explain Risks

Be explicit about:
- **Requires restart?** Yes/No
- **Session impact?** Disconnect / Brief pause / None
- **Rollback possible?** How
- **Known issues:** Any doctor warnings or limitations

**Example:**
```
⚠️ Requires gateway restart → brief disconnect from web UI
✅ iMessage config is valid but has groupPolicy warning (minor)
✅ Rollback: Delete channels section and restart
```

### 4. CONFIRM — Get Permission

**Always ask one of:**

**Option A: Standard**
- "Apply this change now? (Will restart gateway = brief disconnect)"
- "Apply later on next session?"
- "Want to edit it yourself?"

**Option B: Urgent only**  
- "This is time-sensitive — apply now, or wait?"

### 5. APPLY — Do It Right

1. **Apply the edit**
2. **Validate the result** (JSON still valid?)
3. **If restart needed:** 
   - Warn: "Restarting now — will disconnect briefly"
   - Do the restart
   - Confirm it's back up
4. **Verify:** Test the new feature
5. **Document:** Note what was done in memory/YYYY-MM-DD.md

---

## When It's OK to Skip Steps

**Can skip PROPOSE/CONFIRM if:**
- User explicitly says "just do it" beforehand
- It's clearly non-breaking (e.g., adding a skill file that doesn't require restart)
- User is editing the file themselves

**Can skip restart if:**
- Change doesn't affect runtime (e.g., adding a skill doc)
- User will restart manually later

**NEVER skip:**
- Validation (JSON can break things)
- Documenting the impact (unexpected restarts kill sessions)

---

## Checklist

Before editing any openclaw.json:

- [ ] Understand what this change does
- [ ] Know if it requires restart
- [ ] Warn about disconnect impact
- [ ] Get explicit confirmation
- [ ] Validate JSON before AND after
- [ ] Test after applying
- [ ] Document in memory file

---

## What I Should've Done (iMessage)

❌ **What I did:**
- Showed the config snippet
- Edited immediately on approval
- Restarted without warning about disconnect

✅ **What I should've done:**
- Show exact change + validation
- "This will enable iMessage from +1613... but requires gateway restart"
- "Restart will disconnect us briefly — proceed now or later?"
- Get explicit "Yes, proceed now"
- Apply, validate, warn "Restarting now..."
- Confirm back up

---

**Last Updated:** 2026-03-11  
**Next Review:** Document this protocol in SOUL.md under "How I Work With Franco"
