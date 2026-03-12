# OpenClaw Gateway Event Gap Investigation

**Date:** 2026-03-12  
**Reporter:** Franco  
**Status:** Monitoring

## Issue Summary
Control UI showing "event gap detected (expected seq X, got Y); refresh recommended" messages. Also noticing more heartbeat polling messages in the Control UI than previously (approximately every 30 minutes).

## Observed Behavior
- Event gap warnings appear in Control UI header (same location as disconnect notifications)
- Messages indicate missing sequence numbers (e.g., expected 5483, got 5484)
- Heartbeat polls appearing in UI ~every 30 minutes
- Manual refresh required to restore session
- Issue started after OpenClaw reinstall on 2026-03-11

## Investigation Findings

### Gateway Status
- Gateway stable (PID 11955 since 2026-03-11 20:30)
- No crashes detected
- Health-monitor running (interval: 300s / 5 min)

### Log Analysis
Multiple `openclaw gateway status` probes logged:
- 00:07, 04:26, 05:01, 06:45 (today)
- These appear during heartbeat health checks
- Each probe writes to Gateway log file

### Root Cause Hypothesis
The Control UI maintains a sequence counter for Gateway events. When status checks or health-monitor activity occurs, the UI may detect a gap in the event sequence. This is a **warning mechanism**, not a crash — the UI is alerting that it might have missed an event.

The increased heartbeat visibility in the UI suggests either:
1. Post-reinstall configuration difference
2. Health-monitor interval or logging level changed
3. Control UI reconnection behavior modified

## Related Systems
- Gateway health-monitor: 300s interval (5 minutes)
- Control UI WebSocket connection
- LaunchAgent: `ai.openclaw.gateway` (auto-restart enabled)

## Next Steps
1. **Monitor for 48 hours** — Check if frequency decreases as system stabilizes
2. **Document pattern** — Note exact times of heartbeat messages and event gaps
3. **Compare with pre-reinstall behavior** — Check if this is new or previously unnoticed
4. **Evaluate session restoration** — If manual refresh continues to be required, investigate Control UI reconnection logic

## Questions to Answer
- [ ] Did health-monitor interval change in v2026.3.8?
- [ ] Is Control UI logging more verbosely than before?
- [ ] Can session restoration be made seamless without manual refresh?

---
*Last updated: 2026-03-12 06:55 EDT*
