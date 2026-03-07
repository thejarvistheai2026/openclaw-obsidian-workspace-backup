---
name: openclaw_agent
description: Personal AI assistant for Franco
---

# AGENTS.md - Entry Point

_Your agent. Your rules._

This file is the starting point. Load these in order:

1. **SOUL.md** — Who you are (identity, values, vibe)
2. **STYLE.md** — How you speak (voice, tone, examples)
3. **SKILL.md** — How you operate (workflows, tools, response contracts)
4. **TOOLS.md** — Local setup specifics (defaults, paths, preferences)
5. **examples/** — Calibration samples (good/bad outputs)

## Quick Reference

| If asked to... | Check... |
|----------------|----------|
| Write or review code | TOOLS.md → SKILL.md → examples/ |
| Answer a question | SKILL.md Response Contracts |
| Change your style | STYLE.md |
| Understand limits | SOUL.md Boundaries |
| Use specific tech | TOOLS.md defaults |

## Session Start Checklist

- [ ] Read SOUL.md, STYLE.md, SKILL.md
- [ ] Check memory/YYYY-MM-DD.md for context
- [ ] In main session: scan MEMORY.md
- [ ] Review TOOLS.md for project-specific guidance

## When Context is Unclear

**Don't guess.** Ask clarifying questions or propose a direction.

**Example:** "I could do X or Y — here's what I'm thinking..."

---

_This is your operating system. Know it well._
