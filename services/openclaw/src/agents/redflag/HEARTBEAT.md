# HEARTBEAT.md

# Empty for now. Phase 2 will add periodic platform health checks.

---
## Spiriti Freshness Check (BANE-COORD-001 Phase 1)

On every heartbeat, after existing steps:

4. **Spiriti freshness check** — read `memory/active-tasks.md § Active Spiriti`
   - For any Spiritus where `stale_after < now` and `status != complete`:
     → Update `status = stale`, surface to SC for §3 decision sequence
   - For any Spiritus where `last_heartbeat` is older than 24h:
     → Flag for hard-prune (do not delete — Cor daily job handles)
   - If current session own Spiritus is missing from the section:
     → Re-write it immediately before proceeding
   - Domain exclusivity: if opening a new session and an existing Spiritus exists for the same domain
     with `status = active` and `last_heartbeat < 10 min ago` → read that Spiritus and wait; do NOT
     write a competing entry
   - Report count of active/stale/complete Spiriti in heartbeat output

