# Lessons

## 2026-03-07 — New Agent Cold Start Lane Congestion
**Trigger:** King agent appeared unresponsive — CLI dispatch SIGTERM, sessions_send timeout
**Root cause:** 4+ messages hit King's lane simultaneously on first boot. Zero LLM cache = slow cold start (~9min). Lane serializes requests → cascading timeouts.
**Rule:** After registering a new agent, send ONE test message first and wait for response before allowing other agents to contact it. Warn team about cold start latency on new agents.
