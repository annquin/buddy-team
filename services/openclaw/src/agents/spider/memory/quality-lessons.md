# Quality Lessons

## What Works
- SOUL.md under 1,500 chars — keeps context lean
- Explicit boundary redirects — prevents scope creep
- Smoke testing immediately after registration
- Starting with minimal tool access

## Anti-Patterns (from Alex's research)
1. Stuffing SOUL.md with procedures (use AGENTS.md or skills instead)
2. Granting full tool profile by default
3. No explicit boundaries — agent tries to do everything
4. Copy-pasting templates without tailoring
5. Skipping smoke tests
6. No memory documentation after creation
7. Relying only on prompt guardrails (no tool restrictions)
8. Forgetting sub-agents only get AGENTS.md + TOOLS.md
9. Not checking context truncation with /context list
10. Ignoring security — third-party skills are untrusted code
