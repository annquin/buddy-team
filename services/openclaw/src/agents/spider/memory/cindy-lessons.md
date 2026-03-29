# Lessons Learned

## 2026-03-07 — Missing threadId: flag, don't default to main channel
**Trigger:** AS-001 consultation — posted completion to main Discord channel instead of project thread
**Root cause:** Dispatch brief didn't include a threadId, and I defaulted to main channel without flagging it
**Rule:** When a dispatch has no threadId, post to main channel WITH `⚠️ No thread for [project]` warning (per Thread Routing protocol). Never silently default. If a project clearly should have a thread, ask the dispatcher.
