# Memory Curation — Research Summary

Condensed from Alex's full research: `/home/midang/.openclaw/repo/docs/research/2026-03-09-memory-curation-best-practices.md` (18 sources)

## Key Findings

### Persistence Decision Framework (Sources: OpenAI Cookbook, AWS AgentCore, MemOS)
- 4-question test: matters in 7+ days? losing causes mistakes? fact not process? can't re-derive?
- Three tiers: always persist (MEMORY.md), daily log, don't persist
- "Forgetting is not a bug — it is essential" (MemOS paper)

### Entry Format for Hybrid Search (Sources: OpenClaw docs, RAG literature)
- Chunk size: ~400 tokens target, 80-token overlap
- Vector search (70%): needs natural language topics, context, rationale
- BM25 (30%): needs exact identifiers in backticks — IDs, config keys, error strings
- MMR (λ=0.7): penalizes near-duplicate chunks — fewer complete entries > many overlapping fragments

### Deduplication (Sources: OpenAI Agents SDK Cookbook, AWS AgentCore)
- Semantic dedup at write time: memory_search > 0.85 similarity = update, 0.6–0.85 = cross-reference, < 0.6 = new entry
- Periodic consolidation: merge entries on same topic into single authoritative entry
- Supersede, don't delete: preserves history while preventing stale retrieval

### MEMORY.md Size (Sources: Claude Rules research, Claude Code memory system)
- Claude adherence drops with file size
- Recommended ≤120 lines for MEMORY.md
- Overflow to memory/<topic>.md (still indexed by memory_search)

### Temporal Decay Optimization (Source: OpenClaw docs)
- MEMORY.md is immune to decay — durable facts go here
- Daily logs: 30-day half-life. Promote relevant entries before they fade
- Promotion check at 14+ days: is this entry still relevant? → move to MEMORY.md

### Existing Team Research (5 files)
- `claude-memory/2026-03-01_claude-code-memory-system.md` — 200-line limit, topic file offloading
- `2026-03-07-context-management-research.md` — compaction lifecycle, memory flush, context budget
- `topic-5.md` — production memory architectures, external memory cheaper after ~10 turns
- `2026-03-05-openclaw-agent-best-practices.md` — 8 context preservation techniques
- `claude-rules/2026-03-01_claude-rules-best-practices.md` — under 200 lines per file for adherence
