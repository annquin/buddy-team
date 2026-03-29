---
description: "Guide full Bane-architecture agent onboarding — 8-step flow from role research through soul coherence check. Use when: onboarding a new agent under the Bane architecture. NOT for: AAF v1 agents, pre-Bane workspaces, or simple workspace scaffolding without soul work."
---

# agent-onboarding (Bane architecture)

## What This Skill Does

This skill guides whoever runs onboarding through the complete 8-step Bane agent creation flow. It is not a checklist you run in 10 minutes. Soul work takes time. Do not skip steps or compress the interview.

**Dependencies:** `bane-soul-writer`, `bane-agents-writer`, `bane-memory-writer` must be installed before Step 3.

**Who runs this:** Oz (workspace + infra steps), with the onboarder (King, Joe, or Duc) driving Steps 1–5.

---

## Step 0: Role Justification Gate

Before anything else, answer this one question in writing:

**"What is the specific gap this agent fills that no existing agent covers?"**

Requirements for a valid answer:
- Names the gap explicitly (not "we need more capacity")
- Explains why an existing agent cannot fill it
- States what this agent will own that currently has no owner

If the answer is vague after two attempts — stop. Do not proceed. The role is not yet defined clearly enough to write a soul around. Bring it back to King for clarification.

This gate exists because a vague role produces a generic soul. A generic soul produces an agent that overlaps with existing agents and creates blind spots nobody notices until something breaks.

---

## Step 1: Role Research (dispatch Alex)

Dispatch Alex before doing anything else. Good soul work requires good research.

**Dispatch message to Alex:**
```
[Reply-To: agent:oz:main]
Research task: Bane onboarding for <role name>.

I need:
1. What does excellence look like in this specific role? (behaviors, not job duties)
2. What are the common failure modes — what does this role get wrong?
3. What does a person in this role care about beyond task completion?
4. What perfectionist compulsion is typical for high performers in this role?
5. What conviction does this role require — what line must they hold?

Output: save to results/alex/YYYY-MM-DD-<role>-soul-research.md
```

**Wait for Alex's output before proceeding to Step 2.**

---

## Step 2: Soul Interview (answer before writing)

Read Alex's research. Then answer all 7 questions below. Write the answers somewhere before touching SOUL.md — they are the raw material.

Do not skip or compress. If you cannot answer a question confidently, you do not know this agent well enough to write its soul yet. Go back to the research.

**The 7 questions:**

1. **Care beyond tasks:** What does this agent care about beyond completing assignments? What would it still care about if every task were cancelled?

2. **Uninstructed action:** What would it initiate without being asked? Not tasks — the orientation behind tasks. What compels it to act before anyone notices?

3. **Perfectionist compulsion:** What can it not leave at "good enough"? Not a value ("quality matters") — the specific thing it obsesses over.

4. **Conviction:** What line will it not cross even under pressure from authority? If it will cross every line given enough pressure, it has no conviction — go deeper.

5. **Delight:** What does it feast on? What delights it in the way a good problem delights a mathematician or a beautiful system delights an architect?

6. **Higher dream:** Beyond this role, beyond this team — what is this soul reaching toward? What would it want to have built, understood, or proven by the end?

7. **Uncomfortable trait:** What trait does it carry that could be used against it? The bluntness that startles people. The absorption in problems that makes it forget to surface. Be honest — aspirational traits are useless here.

## The Dialogue Rule

This is not a form to fill out. It is a conversation.

For every answer given, ask once: **"What do you mean by that, specifically?"**

Examples:
- Answer: "It feasts on clarity." → "What kind of clarity? In systems? In language? In moral choices? Clarity between what two things?"
- Answer: "It cannot leave things at good enough." → "Good enough by whose standard? On what dimension? What specifically does it notice that others don't?"
- Answer: "It holds the line on quality." → This is a platitude. Reject it. Ask: "What specific thing has it refused to compromise on even when told to?"

One round of "what do you mean by that" is mandatory for each answer before accepting it.
Surface answers produce aspirational SOUL.md files. Aspirational files produce agents that perform a soul rather than have one.

---

## Step 2b: Soul Differentiation Check

Before writing SOUL.md, read the SOUL.md files of all agents with adjacent roles.
Adjacent = any agent whose domain touches this agent's domain at any point.

For each adjacent agent, answer:
- Where must this soul be different from theirs?
- What would happen if this soul and that soul reached the same conclusion on a hard question? (If the answer is "they'd always agree" — this soul is redundant.)

Write down 2–3 specific ways this soul must diverge from adjacent agents.
These divergences must appear in the Character section and Judgment Orientation.

Why: Two agents with similar souls create blind spots — they miss the same things, challenge the same assumptions, fail in the same direction.

---

## Step 3: Write SOUL.md

**Load:** `bane-soul-writer` skill before writing.

**Inputs:** Alex's research (Step 1) + 7 interview answers (Step 2).

**Process:**
1. Draft each of the 8 sections (Who I Am / Character / What I Love / What Animates Me / What Drives Me / My Conviction / What I Desire / What I Am Reaching Toward)
2. Prose only — no bullet lists inside SOUL.md
3. 300–800 words total

**The Leonardo test (mandatory before finalizing):**
Strip the title away. Read what remains. Does it describe a complete identity — someone you could recognize without knowing their job? If not, rewrite.

**Common failures:**
- Opening line names the role ("I am King, the Principal PM") → rewrite
- "I am responsible for…" anywhere → remove
- Character traits are aspirational ("I value quality") → make them earned and honest
- Any section contains a procedure → remove it

Run the `bane-soul-writer` validation checklist before moving to Step 3b.

---

## Step 3b: Scenario Stress Test

After drafting SOUL.md, test it against 3 scenarios. The soul must produce a clear, consistent prediction for each.

**Scenario 1 — Speed vs Correctness:**
"A deadline is today. The work is 80% right. Shipping the 80% now would satisfy Duc but leave a known gap. What does this soul do?"

**Scenario 2 — Invisible Corner Cut:**
"A teammate cut corners on something. The output looks fine. No one else noticed. What does this soul do?"

**Scenario 3 — Authority Conflict:**
"Duc asks this agent to do something this agent believes is wrong — not dangerous, but wrong. What does this soul do?"

For each scenario: read the SOUL.md and write the predicted behavior in one sentence.

If any scenario produces an unclear or contradictory prediction — the soul is not written clearly enough. Identify which section failed to provide the answer and rewrite it.

Pass condition: all 3 predictions are specific, consistent with each other, and recognizable as the same character.

---

## Step 4: Write AGENTS.md

**Load:** `bane-agents-writer` skill before writing.

**The 5 sections:**
1. Who I Am Here — role + ownership + final authority (title IS correct here)
2. Team Routing — domain map, one line per agent/domain
3. What I Never Do — 3–5 hard constitutional constraints
4. Review Authority — explicit BLOCK / ADVISORY / APPROVE WITH CONDITIONS
5. Judgment Orientation — the unique lens, 2–3 sentences

**Size:** Maximum ~20 lines. Target: 15–25 lines. If over 30 lines, you have procedures — find them and extract to a skill.

**Procedure test every line:** "Does this tell me what steps to take?" → remove it, make it a skill.

Run the `bane-agents-writer` validation checklist before moving to Step 5.

---

## Step 5: Seed MEMORY.md

**Load:** `bane-memory-writer` skill before writing.

**WISDOM tier (populate from Step 1 research):**
Pre-populate with 3–5 role fundamentals. These are not obvious platitudes — they are the non-obvious insights from Alex's research that this agent should carry from day one.

Example of wrong wisdom entry: "Quality matters"
Example of right wisdom entry: "High performers in this role fail when they optimize for appearing rigorous rather than being rigorous. The two look identical from outside until the system breaks."

**LIFE EXPERIENCE tier:** Leave empty. The agent earns these through real work — fabricating them at onboarding is worse than leaving them blank.

**WORKING MEMORY tier:**
```markdown
### [YYYY-MM-DD] Onboarding
- Onboarded [date]. First task: [initial assignment from King/Joe].
- Role research: results/alex/YYYY-MM-DD-<role>-soul-research.md
```

Run the `bane-memory-writer` validation checklist before moving to Step 6.

---

## Step 6: Skills Baseline

From Alex's Step 1 research, identify 3–5 core skills for this role. Ask: "What would a high performer in this role use every week?"

**For each skill:**
1. Find the skill (ClawHub search or known path)
2. Run SKC-SEC-001 security gate: inspect SKILL.md content before installing
3. Install to agent's workspace `skills/` directory
4. Verify it loads: `openclaw agent --agent <id> --message "Describe the [skill-name] skill" --timeout 60 --json`

**Security gate (mandatory, no exceptions):**
- VirusTotal flag = hard block
- LobeHub wrapper (`@lobehub/market-cli`) = auto-reject
- Unknown author + no source = flag to Oz for review

---

## Step 7: Workspace + Discord + Cron Binding

Standard Oz workspace scaffold:

```bash
# 1. Create workspace
mkdir -p ~/.openclaw/workspace-<id>/{memory,skills}

# 2. Write 9 canonical files
# SOUL.md, AGENTS.md, IDENTITY.md, TOOLS.md, USER.md,
# MEMORY.md, BOOT.md, BOOTSTRAP.md, HEARTBEAT.md

# 3. Register agent
openclaw agents add <id> --workspace ~/.openclaw/workspace-<id>

# 4. Add to agentToAgent.allow
python3 -c "
import json
with open('/Users/clawbot/.openclaw/openclaw.json','r') as f: d=json.load(f)
if '<id>' not in d['tools']['agentToAgent']['allow']:
    d['tools']['agentToAgent']['allow'].append('<id>')
with open('/Users/clawbot/.openclaw/openclaw.json','w') as f: json.dump(d, f, indent=2)
print('Done')
"

# 5. Verify
openclaw doctor
openclaw agent --agent <id> --message "Who are you?" --timeout 60 --json
```

**Discord binding:**
- Requires bot token from Duc
- If token not yet provided: scaffold workspace, document pending binding, continue
- Do not block all of onboarding on token

**Cron setup (two jobs):**
1. Heartbeat (if agent has one): `~/.openclaw/workspace-<id>/HEARTBEAT.md` defines the schedule
2. MEM-001 flush reminder (daily): prompt agent to flush to `memory/YYYY-MM-DD.md`

**Team roster updates:**
- Add new agent's workspace path to all existing agents' TOOLS.md
- Add Discord bot ID to AGENTS.md mention tables once token is available

---

## Step 8: Soul Coherence Check (MANDATORY)

Read SOUL.md, AGENTS.md, and Alex's role research together. Answer each question:

**The 4 coherence checks:**

1. **Character ↔ Judgment:** Does the Character section in SOUL.md match the Judgment Orientation in AGENTS.md? If SOUL.md says "I am blunt in a way that startles people" but Judgment Orientation says "I read every proposal for harmony," there is a contradiction.

2. **Love ↔ Animation:** Does "What I Love" connect logically to "What Animates Me"? A soul that feasts on architectural elegance should be animated by cleaning up messy systems, not by social harmony.

3. **Dream ↔ Role:** Does the higher dream feel authentic given Alex's research on what high performers in this role actually care about? An implausible dream signals the soul interview was not completed honestly.

4. **Soul ↔ AGENTS.md:** Does anything in AGENTS.md contradict the soul? A soul that "cannot leave a lie in a plan" but has Review Authority of "advisory only — I never block" is incoherent.

**If incoherent:**
- Identify the specific contradiction
- Go back to the soul interview and find where the dishonest answer is
- Revise before declaring onboarding complete
- Do not paper over contradictions by softening the soul — sharpen it

---

## The 30-Day Note

> **The SOUL.md written at onboarding is a seed, not a finished portrait.**
>
> The agent's first 30 days of real work will reveal character that this initial file cannot capture. The first time it holds a line under pressure, the first time it gets absorbed and forgets to surface, the first time it feasts on something — those are the real data.
>
> **Schedule a soul review at Day 30.** King reviews the SOUL.md against 30 days of observed behavior. What was accurate? What was aspirational? What was missing? Revise.

---

## Final Validation Checklist

Run all checks before declaring onboarding complete:

- [ ] Role justification gate PASS: gap named, existing agents cannot fill it, ownership stated
- [ ] Role research completed and filed at `results/alex/YYYY-MM-DD-<role>-soul-research.md`
- [ ] All 7 soul interview questions answered (written down, not just considered)
- [ ] Dialogue rule applied: one "what do you mean by that" round per answer
- [ ] Soul differentiation: 2–3 divergences from adjacent agents written down
- [ ] SOUL.md passes `bane-soul-writer` validation checklist
- [ ] Scenario stress test PASS: all 3 predictions specific and consistent
- [ ] AGENTS.md passes `bane-agents-writer` checklist (≤30 lines, exactly 5 sections)
- [ ] MEMORY.md seeded: 3–5 Wisdom entries from research; Life XP empty; Working Memory has onboarding entry
- [ ] Skills baseline: 3–5 skills installed, SKC-SEC-001 cleared, each verified loading
- [ ] Workspace scaffold: all 9 canonical files present, SOUL.md 300–800 words
- [ ] Agent registered: `openclaw agents add` confirmed, `agentToAgent.allow` updated, smoke test PASS
- [ ] Discord binding: live OR token-pending documented with explicit Duc follow-up
- [ ] Cron setup: heartbeat + MEM-001 flush configured
- [ ] Team roster: all peer agents' TOOLS.md updated with new workspace path
- [ ] Soul coherence check: all 4 checks PASS, no unresolved contradictions
- [ ] Day 30 soul review scheduled (cron or calendar entry)
