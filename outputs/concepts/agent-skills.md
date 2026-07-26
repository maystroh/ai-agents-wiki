---
title: Agent Skills (SKILL.md)
tags:
  - skills
  - core-concept
  - agent-engineering
aliases:
  - Skills
  - SKILL.md
sources:
  - agent-skills-tips
  - testing-skills
  - perplexity-skills
  - how-to-work-with-ai
  - yc-chief-codes-10000-lines
  - stop-babysitting-agents
  - beyond-basics-claude-code
  - tool-skill-subagent-decomposition
updated: 2026-05-28
---

# Agent Skills (SKILL.md)

## What is a Skill?

A **skill** is a folder with a `SKILL.md` file and optional helper files. It augments an agent's capabilities without retraining the model. Skills use **progressive disclosure** — the agent only loads what it needs, when it needs it.

```
my-skill/
├── SKILL.md          ← Required. Frontmatter trigger + instructions.
├── scripts/          ← Deterministic code the agent runs, not reinvents
├── references/       ← Heavy docs, loaded conditionally
├── assets/           ← Templates, schemas, output formats
└── config.json       ← First-run setup
```

Three layers loaded in sequence:

| Tier | What loads | Budget | When paid |
|------|-----------|--------|-----------|
| **Index** | `name: description` for every skill | ~100 tokens | Every session, always |
| **Load** | Full `SKILL.md` body | ~5,000 tokens | When skill triggers |
| **Runtime** | `scripts/`, `references/`, `assets/` | Unbounded | Only when agent reads them |

> [!important] Every Skill is a tax
> The index-tier cost is paid on every session for every user. Each skill slightly degrades every other skill. The bar to enter the index must be high. — Perplexity

## Two Types of Skills

- **Capability skills** — help the agent do something the base model can't do consistently (e.g., PDF form filling, specific API usage). May become obsolete as models improve. Evals tell you when to retire them.
- **Preference skills** — encode your specific workflow (e.g., team's code review steps, deployment checklist). Durable, but must stay in sync with actual practice.

## The Description is the Hardest Part

The `description` is a **routing trigger**, not documentation. It controls when the skill loads. A bad description either misses real use cases or fires on everything.

| ❌ Too vague | ✅ Specific and actionable |
|---|---|
| *"Helps with documents"* | *"Load when creating, editing, or analyzing .docx files for tracked changes, comments, formatting, or text extraction"* |
| *"API helper"* | *"Load when writing code that calls the Gemini API for text generation, multi-turn chat, image generation, or streaming"* |

> [!tip] Checklist for a good description
> - Starts with "Load when..."
> - Target 50 words or fewer
> - Describes user intent (real queries), not what the skill does
> - Does not summarize the workflow

A description rewrite alone fixed 5 of 7 eval failures on Philipp Schmid's Interactions API skill (boosting pass rate from 66.7% → 100%).

## Writing the Body

**Skip the obvious.** If the model already knows it, don't write it. Write what it would get wrong without the skill.

> [!example] Gotchas over commands
> Don't write: `git log # find the commit; git checkout main; git checkout -b <clean-branch>; git cherry-pick <commit>`
> 
> Write instead: *"Cherry-pick the commit onto a clean branch. Resolve conflicts preserving intent. If it can't land cleanly, explain why."*

Key principles:
- **Use directives, not information.** "Always use `interactions.create()`" vs "The Interactions API is the recommended approach." Agents follow instructions, not trivia.
- **Lead with examples.** A 5-line code snippet beats a 5-paragraph explanation.
- **Explain the why.** "Use model X, model Y is deprecated and will return errors" helps the agent generalize.
- **Focus on gotchas.** These are the highest-value content — they prevent known failures.
- **Don't over-prescribe.** Step-by-step workflows prevent agents from adapting. Describe outcomes, not procedures. Provide constraints, not procedures.
- **Under 500 lines** for the body. Longer content goes in reference files.

## The Hierarchy

Use the folder structure creatively:
- `scripts/` — deterministic logic the agent would reinvent every run; give it code to compose, not reconstruct
- `references/` — heavy docs, loaded conditionally ("Read `api-errors.md` if API returns non-200")
- `assets/` — output templates the agent copies and fills

For very complex domains, use **multi-level hierarchy**: Perplexity's tax Skills had 3 levels of topical nesting for 1,945 IRS code sections — presenting all at once actually *degraded* performance.

## Testing Skills

> [!warning] Don't ship untested skills
> SkillsBench counted 47,000+ skills across 6,300+ repos. Most are AI-generated and "vibe-checked" with a handful of manual runs.

A proper eval harness:
1. **Write evals first** (before writing the skill body)
2. **10–20 prompts** mixing should-trigger, shouldn't-trigger, and edge cases
3. **Run multiple trials** (3–5 per prompt — agent output is nondeterministic)
4. **Write deterministic checks** (regex, file existence, compile checks) for most assertions
5. **Add LLM-as-judge** only for qualitative dimensions that can't be checked deterministically
6. **Isolate each run** — context bleeding between tests masks real failures
7. **Don't skip negative tests** — a skill with too-broad description fires on every request

See [[testing-skills|Practical Guide to Evaluating Skills]] for the full harness implementation.

## Retiring Skills

Run evals *without* the skill. If they still pass, the model has absorbed the skill's value — retire it. This is especially important for capability skills as models improve.

> [!quote] Self-generated Skills provide no benefit
> "Self-generated Skills provide no benefit on average, showing that models cannot reliably author the procedural knowledge they benefit from consuming." — SkillsBench (arXiv 2602.12670)

## Skills as Method Calls

Garry Tan's framing: **skill files are method calls**, with markdown as the programming language and human judgment as the runtime. The same `/investigate` skill pointed at a safety scientist or at FEC filings produces radically different outputs — because the skill encodes *judgment* and the invocation supplies *the world*.

This framing clarifies what a good skill body contains: reusable decision logic, not the data those decisions operate on. The skill is a template for reasoning; the context supplies the facts.

**Corollary:** If you ask your agent for the same thing twice, you're already losing. Every repeatable task should become a skill file rather than a recurring prompt. The second invocation is the signal to abstract.

## Diarization — Deep Analysis via Skills

**Diarization** is a skill pattern for turning document retrieval into genuine analysis. The model reads a full document set about a subject and produces a structured single-page brief — a distillation no SQL query or RAG pipeline can replicate, because it captures relationship and nuance, not just retrieval.

Garry Tan uses it at YC Startup School: 6,000 founder profiles run nightly through a diarization skill, surfacing the gap between what founders *say* they're building and what their commit history *shows*. The analysis is richer than any search or filter because it requires synthesis.

When to use diarization:
- Gap analysis (stated intent vs evidence)
- Due diligence / profile synthesis
- Cross-document summarization requiring judgment

Latent vs deterministic distinction applies: diarization belongs in the model (latent space). Simple retrieval, counting, or sorting belongs in deterministic tooling. Forcing a deterministic task through a model produces plausible-but-wrong outputs.

## Verification Skills — Self-Improving Skills

A **verification skill** packages how Claude checks its own work — and is explicitly told to update itself whenever it hits a blocker. The result is a self-documenting, self-improving skill that grows more reliable over time.

**Why this matters:** Instead of holding Claude's hand through verification on every run, you teach it once (manually showing it which tools to use and what to check), then extract those learnings into a SKILL.md. From then on, every teammate and future invocation benefits — and every new blocker the skill encounters gets added to the skill body automatically.

**Structure of a verification skill:**
1. Run the application (dev server, Docker Compose, etc.)
2. Open a browser via Chrome MCP or Playwright
3. Execute a smoke test sequence (navigate, interact, screenshot)
4. Check for failures, retry if needed
5. **Self-update instruction:** "If you hit a blocker not covered by this skill, add it to the skill so it's handled next time"

The Claude Code team uses this pattern internally: a single verification skill that documents itself. Every engineer on the team contributes blockers they hit, and the skill accumulates them.

> [!tip] Verification first
> Package verification *before* you automate — knowing how to validate means you can run Claude in background loops with confidence that it'll catch its own mistakes.

## Skills at Scale — The 100K Skill Problem

Skills work well up to hundreds of skills. At monorepo scale (tens of thousands of skills), the index-tier cost dominates:

- Each skill description adds ~100–400 tokens to every session, unconditionally
- At 100,000 skills, most of the context window is consumed by skill descriptions before the task begins
- Skills don't currently support hierarchy — you can't lazily expose sub-skills

**Hooks as the zero-overhead alternative.** When you can't afford the index-tier tax:

| | Skills | Hooks |
|---|---|---|
| Token cost | ~100–400 tokens per skill, always | Zero unless triggered |
| Trigger mechanism | Description match | Event type (post-tool, session start, etc.) |
| Expressiveness | Rich instructions, examples | Script-based; limited to event types |
| Hierarchy | None yet | N/A |
| Scale | Practical limit ~hundreds | Scales to 100,000+ |

Hooks are the "red squigglies" of the agentic IDE — nudges and reminders that run outside the context window. A hook that type-checks your JavaScript file pays zero cost on Rust files. Skills always pay their description cost.

**Skill hierarchy is coming.** Anthropic is working on sub-skills (lazy exposure of sub-skills) to improve scalability. Until then, use hooks for universal event-driven checks and skills for triggered domain knowledge.

## Skills as System Prompt Relief Valve

A bloated system prompt is a common failure mode as agents accumulate business requirements over time. The pattern: each new capability → more text appended to system prompt → conflicts arise → eval scores drop.

**The fix:** Move domain rules, policies, and procedures from the system prompt into skills. The system prompt should contain only what Claude needs *regardless of task* — its identity, tools, and core behavior. Everything else is conditional knowledge that belongs in skills.

**StockPilot example** (Will, Anthropic Applied AI, 2026):
- Before: 400-line system prompt accumulating two years of business requirements, 12 tools, 3 subagent wrappers → eval score 62%
- After: 15-line system prompt + skills for each domain (forecasting guidelines, supplier selection policies, etc.) → eval score 92%

The eval failure mode that skills fix: two policies in different sections of a long system prompt contradicting each other. The model sees both, gets confused, and hallucinates — not a model capability problem but a context design problem.

**Why this works:** Skills load conditionally. If Claude is asked to file a PO, it loads the supplier selection skill; if asked to forecast, it loads the forecasting skill. Claude never sees policies irrelevant to the current task. Context stays clean; reasoning stays focused.

## Skills vs AGENTS.md

| | Skills | AGENTS.md |
|---|---|---|
| **Loading** | On-demand (triggered by description) | Every session, always |
| **Scope** | Specific task/workflow | Global codebase context |
| **Size** | Up to 500 lines body + reference files | Under 300 lines (ideal under 60) |
| **Change cadence** | Frequent (add gotchas as agent fails) | Rare (infrastructure, not scratchpad) |

## See Also
- [[agent-harness]] — the system that loads and executes skills
- [[mcp-servers]] — MCP as an alternative extension mechanism
- [[context-engineering]] — progressive disclosure as a context strategy
- [[closing-the-loop]] — outer loop: auto-generating skills from failures
- [[evals-and-graders]] — skill evals; trigger tests; skill retirement criteria
- [[inner-outer-loop]] — skills as the primary outer loop persistence mechanism; auto-generated skills carry lessons from failures across sessions
- [[agents-evolution]] — skills are the primary implementation of Agents 2.0 Pillar 4 (Extreme Context Engineering)
- [[subagent-patterns]] — the third leg of the tool/skill/subagent decision framework; when skills are insufficient, subagents are the next escalation path
- [[agent-engineering]] — Skills as Method Calls encodes "taste"/judgment as reusable logic; the same problem agent-engineering's Taste Problem section names as hard to delegate
