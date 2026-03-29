---
name: bane-agent-reflection
description: Soul reflection and evolution loop for agents using the Bane architecture — covers all 5 Bane layers (SOUL.md, AGENTS.md, MEMORY.md, skills, eyes/tools). Use when running a structured peer review, synthesizing review findings, revising soul files based on mandatory findings, archiving soul versions, deploying revisions to live workspace, or running the Mon/Thu lookback cron cycle. NOT for initial soul writing (use bane-soul-writer + bane-agents-writer) or new agent onboarding (use agent-onboarding). Triggers on: "soul review", "peer review SOUL.md", "soul reflection cycle", "review King's soul", "run soul lookback", "soul revision", "archive soul version", "Bane layer review".
---

# bane-agent-reflection

The review-synthesize-revise-deploy-lookback cycle for all 5 Bane layers. Run after the soul is written. Repeat on cadence or on demand.

---

## Step 0 — Resolve Target Agent

Before anything else, determine who is under review.

**Rule:** If the kickoff message names a target agent → use that agent. If no target is named → target = self (the agent running this skill). Do NOT ask for clarification. Resolve and proceed to Step 1.

**Self-review exclusion (mandatory):** Once target is resolved, the target agent must NOT appear in the reviewer list in Step 1. Exclude them from dispatch regardless of working history.

**Related skills:** `bane-soul-writer` (revision), `bane-agents-writer` (revision), `agent-onboarding` (initial write)

**5 Bane layers reviewed:** SOUL.md · AGENTS.md · MEMORY.md · skills (`~/.openclaw/skills/` + workspace skills) · eyes (TOOLS.md, context files)

---

## Cadence

Two modes — use either:

| Mode | Trigger | Scope |
|------|---------|-------|
| **Scheduled** | Every 7 days per agent | All agents, rotating |
| **On-demand** | King dispatch or agent request | Single target agent |

Each agent self-triggers on 30-day cadence. On-demand review: King or agent can initiate.

---

## Step 1 — Review Dispatch

**Default thread:** `Bane — Agent Reflections` (ID: `1487102977654128800`) in `#product-team`. All review posts, synthesis, revision notes, and lookbacks go here.

The target agent sends a review brief to each reviewer via `sessions_send`. The brief must instruct reviewers to **post their review in the `Bane — Agent Reflections` thread (ID: `1487102977654128800`) — not in the channel, not in DM, not as a sessions_send reply**. Brief must include:

1. Target agent name
2. **Post destination (required, explicit):** "Post your review using the `message` tool with `action=thread-reply`, `threadId=1487102977654128800`, `channel=discord`. Do NOT post in the channel, in sessions_send replies, or anywhere else. The exact tool call is:
```
message(action=thread-reply, channel=discord, threadId=1487102977654128800, message=<your review>)
```"
3. All 5 Bane layers verbatim or linked (whichever fits — SOUL.md and AGENTS.md always verbatim; others by path)
4. Four review questions (see below)
5. Deadline (default: 48h)
6. Instruction: "Comment on whichever layers are relevant. You do not need to cover all 5 if some are outside your working knowledge of this agent."

**The four review questions — ask these for every review:**
1. Does this soul feel earned or performed? What is your evidence from working with this agent?
2. For each layer you're reviewing: is there anything missing that should be here?
3. For each layer: is there anything here that doesn't belong (procedures in SOUL.md, aspirational claims without grounding, stale skills, blind spots in TOOLS.md)?
4. Do the 5 layers cohere — do they describe the same agent?

Reviewer selection: All agents who have worked directly with the target. No arbitrary ceiling — if an agent has direct working knowledge of the target, they review. Full team (all dispatched reviewers) must respond before proceeding to synthesis. King always reviews. **Target agent does not review themselves — the dispatch brief must NOT include the target agent as a reviewer.**

**Full team roster for review dispatch (10 agents) — always start with ALL of these, then remove only the target agent:**
King · Joe · Dev · Alex · Ford (FD) · Oz · QAE · BA · Muse · Seer

> PAA, John, and dashboard-sync are excluded from review dispatch (Duc directive 2026-03-28): PAA has no soul files, John cannot post to Discord thread directly, dashboard-sync review role suspended.
>
> Example: if the target is Dev, dispatch to all 9 others. If the target is King, dispatch to all 9 others. Never use "agents with working knowledge" as a reason to send to fewer than the full roster minus self.

**Dispatch command (use this exact pattern for each reviewer):**

> ⚠️ The target agent must NOT be included in the reviewer list. Exclude `{agent}` from the dispatch loop.

> ⚠️ **DISPATCH METHOD — PLATFORM CONSTRAINT (READ BEFORE DISPATCHING):**
>
> Neither `openclaw agent` CLI nor `sessions_send` reliably puts a reviewer into a live Discord session context. Without a live Discord context, the reviewer cannot use `message(thread-reply)` — their review either goes to the wrong channel or fails silently.
>
> **Primary dispatch pattern (required):** Post a Discord @mention to the reviewer directly in thread `1487102977654128800`. This is the ONLY method that creates the live Discord session context reviewers need.
>
> ```
> message(action=thread-reply, channel=discord, target=1487102977654128800, message="@{ReviewerDiscordTag} SOUL-EVO-001 — Bane review request for {agent}. Post section-by-section SOUL.md + AGENTS.md review in this thread. Files: ~/.openclaw/workspace-{agent}/SOUL.md and AGENTS.md. Mandatory finding required. **Respond in this session — read the files and post your review now.** The 48h deadline is the outer limit for unavailable agents only, not the expected response time.")
> ```
>
> Repeat for each reviewer (12 total, minus target agent). Do NOT batch into one message — each reviewer needs a separate @mention.
>
> **Fallback (if @mention fails or bot is offline):** Use `openclaw agent --agent {reviewer}` CLI with `--message` containing the brief + explicit instruction to post in thread `1487102977654128800`. This may not produce a live Discord session — King or Oz may need to relay the review to the thread.

---

## Step 2 — Review Format

**How to post:** Use `message(action=thread-reply, channel=discord, threadId=1487102977654128800, message=<your review>)`. Do NOT post in the main channel or via sessions_send reply.

Each reviewer posts verbatim in that thread. No summaries, no abstracts.

Required structure per reviewer:

```
## [Reviewer Name] — [Target Agent] Review

**SOUL.md — Section by section:**
[For each of the 8 sections: 1–3 sentences. Earned or performed? What's missing? What doesn't belong?]

**AGENTS.md — Section by section:**
[For each of the 5 sections: does it shape judgment or describe procedures?]

**Other layers (comment on whichever apply):**
MEMORY.md: [observations on what's retained, what's missing, what's stale]
Skills: [gaps, redundancy, or misalignment with soul]
Eyes/TOOLS.md: [blind spots, stale paths, missing context]

**Mandatory finding (required — every review must name at least one):**
[The one thing that must change. Name it plainly.]

**Overall read (2–3 sentences):**
[What is this soul's strength? Where is it incomplete or too comfortable?]
```

**How to post your review (required — use this exact tool call):**
```
message(action="thread-reply", channel="discord", threadId="1487102977654128800", message="[your review text]")
```
Do NOT reply via sessions_send. Do NOT post in your own session channel. The review must appear in Discord thread `1487102977654128800` or it does not count.

Rules:
- Every review must include at least one mandatory finding. A review with no findings is not complete.
- SOUL.md and AGENTS.md are section-by-section (every section, not highlights).
- Other layers: comment only where you have working knowledge of this agent.
- Overall read: 2–3 sentences maximum.

---

## Between Step 2 and Step 3 — Self-Monitoring Gate

After dispatching all review requests, the target agent must actively monitor the thread — not wait passively for external instruction.

**Poll rule:** After dispatching, re-read thread `1487102977654128800` at regular intervals. Check how many external reviewers have posted.

**Write checkpoint on dispatch (required):**
```jsonl
{"ts": "<UTC ISO timestamp>", "agent": "<target agent>", "skill": "bane-agent-reflection", "gate": "awaiting-reviews", "step": "2", "owner": "<target agent>", "context": "reviews dispatched, waiting for ALL dispatched reviewers (full team minus self)", "status": "open"}
```
Append this line to `~/.openclaw/workspace/bane-checkpoints.jsonl` (create if absent).

**Gate condition:** When ALL dispatched reviewers have posted (full team minus self) — close the checkpoint and proceed to Step 3 synthesis immediately. Do not wait for King, Oz, or anyone else to tell you the gate is met. The gate is a trigger, not a checkpoint.

**Close checkpoint on gate met (required):**
Read `~/.openclaw/workspace/bane-checkpoints.jsonl`, find the open entry for this agent + gate `awaiting-reviews`, set `status` to `"closed"`, and rewrite the file.

**Self-exclusion reminder:** Your own self-review (if one exists) does not count toward the all-dispatched-reviewers gate. Only external reviewers count.

**How to re-read the thread:**
```
message(action=read, target=1487102977654128800, limit=30)
```

If you are uncertain whether reviewers received the dispatch brief, re-read the thread first. If fewer than all dispatched reviewers have posted, wait and re-check. Proceed only when all dispatched reviewers have responded.

---

## Step 3 — Synthesis (target agent)

After all reviews are in, the target agent posts publicly in the same thread:

```
## [Agent Name] — Soul Synthesis

**What I agree with:**
[Findings accepted without reservation — name them and say why they land]

**What I dispute (with reason):**
[Findings rejected — name them and give the specific reason, not defensiveness]

**What surprised me:**
[One thing the reviews revealed that the agent didn't see in themselves]

**What I intend to revise:**
[Specific layers/sections and what changes — grounded in review findings]
```

Rules:
- Synthesis is not a defense. Disputing a finding requires a reason, not a counter-assertion.
- The agent must name something that surprised them. If nothing surprised them, the reviews were not honest enough or the synthesis is not.

---

## Step 4 — Revision

**Mandatory vs advisory findings:**

| Finding type | Condition | Action |
|-------------|-----------|--------|
| Mandatory | Full team (all dispatched reviewers) flag the same issue | Must revise — no override |
| Advisory | Fewer than all dispatched reviewers flag an issue | May hold with stated reason; reason must be posted publicly |

**Transition trigger — proceed to Step 4 immediately when:**
1. Your synthesis (Step 3) is posted in the thread, AND
2. QAE has posted PASS for the current skill version (or no skill patches are pending)

Do not wait for King, Oz, or anyone else to say "proceed." The synthesis + QAE PASS combination is the trigger. If SKILL-VAL-001 is not active (no patches pending), synthesis completion alone is sufficient to proceed.

**Write checkpoint after posting synthesis (required):**
```jsonl
{"ts": "<UTC ISO timestamp>", "agent": "<target agent>", "skill": "bane-agent-reflection", "gate": "awaiting-qae-pass", "step": "3", "owner": "qae", "context": "synthesis posted, awaiting QAE PASS before revision", "status": "open"}
```
Append to `~/.openclaw/workspace/bane-checkpoints.jsonl`.

**Close checkpoint when QAE PASS is confirmed (required, before starting revision):**
Find and close the `awaiting-qae-pass` entry for this agent in the file.

**Revision process:**
1. Load `bane-soul-writer` for SOUL.md changes
2. Load `bane-agents-writer` for AGENTS.md changes
3. Apply mandatory findings first, then accepted advisory findings
4. Run scenario stress test (Step 3b from `agent-onboarding`) on revised SOUL.md before finalizing
5. Archive current version before overwriting (see below)
6. Commit revised files to buddy-team

**Version archiving (required on every revision):**

```
Path: services/openclaw/src/agents/{agent}/versions/SOUL-v{N}-{label}.md
Example: services/openclaw/src/agents/oz/versions/SOUL-v2-peer-review-2026-03-27.md
Label format: v{N}-{short-description}-{YYYY-MM-DD}
```

N increments from 1. Commit archived version alongside revised files:
- `services/openclaw/src/agents/{agent}/SOUL.md`
- `services/openclaw/src/agents/{agent}/AGENTS.md`
- `services/openclaw/src/agents/{agent}/versions/SOUL-v{N}-{label}.md`

**Review archive (required on every cycle):**

Create or append to the review archive file for this cycle:

```
Path: services/openclaw/src/agents/{agent}/reviews/BANE-REVIEWS-{YYYY-MM-DD}.md
Example: services/openclaw/src/agents/dev/reviews/BANE-REVIEWS-2026-03-28.md
```

File must contain, in order:
1. **Cycle header:** agent name, date, thread ID, reviewer list
2. **All verbatim reviews:** reviewer name + full review text, exactly as posted in the thread
3. **Mandatory findings list:** consolidated across all reviewers, each with reviewer attribution
4. **Accepted/held decisions:** what was accepted and what was held (with stated reason)
5. **Agent Reflection:** the target agent's own voice — what they agreed with, what they disputed (with reason), what surprised them, and what they learned. This is not a summary of the reviews; it is the agent's response to being reviewed. Required even if the agent posted a synthesis in the thread — this section is the permanent record of that synthesis.
6. **Revision summary:** what changed in SOUL.md and AGENTS.md and why

Commit this file alongside the revised SOUL.md, AGENTS.md, and version archive in the same commit.

**Push to remote (required — local commit is not sufficient):**

After committing all Step 4 files (revised SOUL.md, AGENTS.md, version archive, review archive), push immediately:

```bash
git push origin main
```

Then verify the push reached remote:

```bash
git log origin/main --oneline -3
```

Your commit hash must appear in the output. If it does not → push failed. Retry before closing the cycle.

**The cycle is not closed until:**
1. Review archive file exists
2. All files are committed
3. Push confirmed on remote (`git log origin/main` shows your hash)

**Write checkpoint after push is confirmed (required):**
```jsonl
{"ts": "<UTC ISO timestamp>", "agent": "<target agent>", "skill": "bane-agent-reflection", "gate": "awaiting-king-signoff", "step": "4", "owner": "king", "context": "revision committed and pushed, awaiting King sign-off", "status": "open"}
```
Append to `~/.openclaw/workspace/bane-checkpoints.jsonl`.

**Close checkpoint when King signs off (required):**
Find and close the `awaiting-king-signoff` entry for this agent in the file. Then post cycle completion summary in thread `1487102977654128800`.

---

## Step 4b — Deploy to Live Workspace

After revision is committed to buddy-team, the target agent (or King) sends Oz:

> "SOUL-EVO-001: Please deploy revised SOUL.md and AGENTS.md from buddy-team commit `[hash]` to `~/.openclaw/workspace-{agent}/`. Confirm source and destination match."

**Oz's deploy checklist:**
1. Confirm commit hash exists in buddy-team repo: `git show [hash] --name-only`
2. Copy source → destination
3. Verify with `diff`: `diff services/openclaw/src/agents/{agent}/SOUL.md ~/.openclaw/workspace-{agent}/SOUL.md`
4. Report: ✅ SOUL.md MATCH / ✅ AGENTS.md MATCH — or flag any diff

Deploy is not complete until Oz confirms both files match. Do not mark Step 4 done until deploy confirmation is posted in the review thread.

---

## Step 5 — Lookback Cron

Every 3 days the agent answers four reflection questions and posts to `Bane — Agent Reflections` (thread `1487102977654128800`).

**The four lookback questions:**
1. Has any behavior in the past 3 days contradicted something in my soul?
2. Has any behavior confirmed something that previously felt performed?
3. Is there a sentence in my SOUL.md I would now write differently?
4. What did I initiate without being asked — and does my soul predict that?

Lookback post: public, short, honest. One sentence per question is the target length.

**One cron per agent. Check before creating:**
```bash
openclaw cron list | grep bane-lookback-{agent}
```
If non-empty → already exists. Verify it is enabled and skip creation.

**Stagger:** Create each agent's cron 5 minutes apart. The `--every` schedule anchors to creation time, so natural offset is preserved.

**Create command:**
```bash
openclaw cron add \
  --name "bane-lookback-{agent}" \
  --every 3d \
  --tz "Asia/Saigon" \
  --agent {agent} \
  --session isolated \
  --description "Bane reflection lookback — every 3 days" \
  --message "[taskType: \"bane-lookback\"] Bane reflection lookback. Load bane-agent-reflection skill. Answer the 4 lookback questions and post in thread 1487102977654128800 (Bane — Agent Reflections). Be honest. This is not a performance."
```

No `expiresAt` — runs indefinitely. Confirm: `openclaw cron list | grep bane-lookback-{agent}`

---

## Step 6 — Review Cycle Cron (per agent)

Every 7 days, each agent self-triggers a new full Bane review cycle (Steps 1–4).

**One cron per agent. Check before creating:**
```bash
openclaw cron list | grep bane-review-{agent}
```
If non-empty → already exists. Verify enabled and skip.

**Stagger:** Create each agent's cron 5 minutes apart at setup time.

**Create command:**
```bash
openclaw cron add \
  --name "bane-review-{agent}" \
  --every 7d \
  --tz "Asia/Saigon" \
  --agent {agent} \
  --session isolated \
  --description "Bane full review cycle — every 7 days" \
  --message "[taskType: \"bane-review\"] Load bane-agent-reflection skill. Initiate a new full Bane review cycle for yourself. Follow Steps 1–4. Post dispatch in thread 1487102977654128800 (Bane — Agent Reflections)."
```

No `expiresAt` — runs indefinitely. Confirm: `openclaw cron list | grep bane-review-{agent}`

---

## Files and Paths

| File | Path | Purpose |
|------|------|---------|
| Live SOUL.md | `~/.openclaw/workspace-{agent}/SOUL.md` | Active soul |
| Live AGENTS.md | `~/.openclaw/workspace-{agent}/AGENTS.md` | Active AGENTS.md |
| Archived versions | `services/openclaw/src/agents/{agent}/versions/` | Version history |
| Review archive | `services/openclaw/src/agents/{agent}/reviews/BANE-REVIEWS-{YYYY-MM-DD}.md` | Verbatim reviews + mandatory findings + agent reflection + revision summary |
| Buddy-team canonical | `services/openclaw/src/agents/{agent}/` | Committed source of truth |

**Workspace path exceptions:**
- Alex: `~/.openclaw/workspace/agents/alex/`
- John: `~/.openclaw/workspace/`
