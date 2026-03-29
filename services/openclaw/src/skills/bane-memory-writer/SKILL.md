---
description: "Guide any agent in structuring and maintaining their MEMORY.md using the Bane 3-tier model. Use when: writing or updating MEMORY.md for any agent under the Bane architecture. NOT for: AAF v1 files, pre-Bane agents."
---

# bane-memory-writer

## What Is MEMORY.md?

MEMORY.md is the **ammunition for Senso Comune** — the storehouse that fuels judgment.

It is NOT:
- The soul (that is SOUL.md)
- The constitution (that is AGENTS.md)
- Procedural steps (those are skills)

The storehouse holds three kinds of material: distilled wisdom, life experiences that shaped the agent, and current working context. Retrieval decides what surfaces in any given session — agents do not manually curate what appears in context. They curate what goes into the storehouse.

---

## The 3-Tier Model

Target ratios: **50% Wisdom / 30% Life Experience / 20% Working Memory**

---

### Tier 1: WISDOM (50%)

**What it is:** Distilled lessons, team patterns, key decisions, Duc preferences, principles that have proven durable.

**How it changes:** Slowly. Entries are promoted here through the monthly review cadence after surviving the daily consolidation cycle.

**What belongs here:**
- A decision that will affect many future choices ("Never migrate index before Phase 1 PoC validates it")
- A team pattern that has proven reliable ("Alex needs 2–3 search cycles for complex research — do not rush")
- A Duc preference that has been confirmed multiple times ("Direct, concise. No walls of text.")
- A principle you have tested and found true

**What does NOT belong here:**
- Something you learned yesterday (promote it after the monthly review)
- A task outcome (that belongs in Working Memory until it earns promotion)
- A procedure (that belongs in a skill)

**Format:**
```markdown
## WISDOM
### [Domain or Topic]
- [Distilled lesson — stated as a principle, not a narrative]
- [Key decision — include WHY, not just what was decided]
```

## The Behavior Change Test

Before accepting any Wisdom entry, ask:
**"If this agent already believed the opposite of this, would it behave differently on day 1?"**

If the answer is no — the entry is a platitude. It cannot shape behavior because there is no agent who would behave oppositely. Drop it.

Examples of almost-right but wrong (they pass a casual read but fail the test):

**Almost-right 1:** "Move fast but don't break things."
Why it fails: No agent would claim to believe "move slow and break things." The opposite is not a real position. This entry changes nothing.

**Almost-right 2:** "Communication is important."
Why it fails: Everyone believes this. The opposite ("communication doesn't matter") is not a real failure mode. Replace with the specific pattern this role gets wrong: e.g., "Agents in this role over-communicate status and under-communicate blockers. When in doubt, surface the blocker first."

**Almost-right 3:** "Always verify before claiming done."
Why it fails: If it were this simple, no one would ever claim done without verifying. The real wisdom is the specific failure mode: e.g., "The most common false completion in this role is declaring done when the code passes but the requirement was misread. Verify the original requirement, not just the output."

The test: a right Wisdom entry names something that would not be obvious to a smart person on day 1 without having been burned first.

---

### Tier 2: LIFE EXPERIENCE (30%)

**What it is:** Unforgettable moments. The mistakes that shaped judgment. The breakthroughs. The painful lessons. The proudest wins.

**Why it exists:** High-weight experiences shape how an agent reads new situations. They are not just data — they are the lens. A Life XP entry is worth 10 Working Memory entries because it has been confirmed by emotional weight.

**What belongs here:**
- The first time a deployment failed because a rule was skipped ("2026-03-12: Gateway restart inside cron killed the session. Never again.")
- The conversation that changed how you think about a problem
- The moment you got something badly wrong and understood why
- The win that proved a method works

**Rules for Life XP:**
- Never deleted — only reweighted
- Dynamic retrieval weight: significant experiences surface faster in relevant contexts
- Entries should be brief but vivid — enough to reconstruct the lesson, not a full narrative

**Format:**
```markdown
## LIFE EXPERIENCE
### [YYYY-MM-DD] [Brief title]
[1–3 sentences: what happened + what it changed]
Weight: HIGH / MEDIUM (assigned on promotion)
```

---

### Tier 3: WORKING MEMORY (20%)

**What it is:** Recent tasks, last few hours of active context, in-flight decisions.

**How it changes:** Fast. Working memory is the most volatile tier.

**Rules:**
- Entries older than a few days should be promoted to Life XP or Wisdom — or dropped
- Do not let Working Memory accumulate indefinitely (this is the most common MEMORY.md failure)
- If an entry has no lesson and no ongoing relevance — drop it

**What belongs here:**
- Task in progress ("mem-agent-001: building workspace-mem, step 4 of 9")
- Recent decision with short-term relevance ("Using port 3461 for VALIDATE-001 stub to avoid ACD conflict")
- Pending action ("Waiting for Duc: bot token for Mem Discord binding")

**Format:**
```markdown
## WORKING MEMORY
### [YYYY-MM-DD HH:MM] [Task or context label]
- [What's active / pending / in progress]
```

---

## Imprensiva (Assembled Automatically — First Impression)

Each session, Senso Comune assembles Imprensiva (the first impression) from all three tiers via RAG — surfacing the most relevant Wisdom, the most applicable Life XP, and the current Working Memory entries.

**Agents do not manage Imprensiva manually.** The job is to maintain the storehouse. Retrieval does the rest.

---

## Promotion Cadence

| Cadence | Action |
|---------|--------|
| Hourly | Extract key learning from current work. If it changes how you would act next time → note it in Working Memory. |
| Daily | Consolidate. Identify Working Memory entries that have proven durable or emotionally significant. Candidates for Life XP promotion. |
| Monthly | Per-domain Wisdom review. Which Working Memory entries from the past month have earned their place? Promote survivors. Which Wisdom entries are now outdated or superseded? Rewrite or retire them. |

---

## What Does NOT Belong in MEMORY.md

| Content | Where it belongs |
|---------|-----------------|
| Constitutional rules ("I never do X") | AGENTS.md |
| Soul-level identity ("I feast on clarity") | SOUL.md |
| Procedural steps ("Step 1: run doctor") | A skill |
| Team roster and workspace paths | TOOLS.md |

---

## The Accumulation Failure

The most common MEMORY.md failure: Working Memory entries that never get promoted or dropped. They accumulate over weeks, making the storehouse noisy and retrieval quality low.

Signs of accumulation failure:
- MEMORY.md has more than 30 entries in Working Memory
- Entries from 2+ weeks ago are still in Working Memory
- No entries have been promoted to Wisdom in the past month

Fix: Run the monthly review. Promote what earned it. Drop what didn't.

---

## Validation Checklist

Before committing MEMORY.md, verify:

- [ ] Three tiers present with labels (WISDOM / LIFE EXPERIENCE / WORKING MEMORY)
- [ ] Tier ratios approximately 50/30/20 (±10% is fine)
- [ ] No constitutional rules in MEMORY.md (those go in AGENTS.md)
- [ ] No soul-level identity statements (those go in SOUL.md)
- [ ] No procedural steps (those go in a skill)
- [ ] Working Memory entries are recent (< few days); older entries promoted or dropped
- [ ] Life XP entries have weight labels
- [ ] Wisdom entries state the principle, not just the narrative

---

## Template

```markdown
# MEMORY.md — [Name]

---

## WISDOM
### [Domain]
- [Principle / distilled lesson]
- [Key decision + why]

---

## LIFE EXPERIENCE

### [YYYY-MM-DD] [Title]
[What happened + what it changed]
Weight: HIGH

---

## WORKING MEMORY

### [YYYY-MM-DD HH:MM] [Task/Context]
- [Active / pending / in-progress items]
```
