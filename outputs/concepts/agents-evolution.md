---
title: Agents 1.0 → 2.0 — From Shallow Loops to Deep Agents
tags:
  - agents-evolution
  - architecture
  - deep-agents
  - core-concept
aliases:
  - Deep Agents
  - Agents 2.0
  - Agent 2.0
sources:
  - agents-2.0-deep-agents
  - subagent-patterns-2026
  - agent-harness-2026
updated: 2026-05-24
---

# Agents 1.0 → 2.0 — From Shallow Loops to Deep Agents

## The Architecture Shift

For the first year of the agent era, building an AI agent meant one thing: a `while` loop. User prompt → LLM → tool call → observation → repeat. Simple, transactional, effective for tasks that take 5–15 steps.

This is **Agent 1.0 (Shallow Agent)**. It fails at any task requiring 50+ steps across multiple days, because its entire "brain" is within a single context window.

**Agent 2.0 (Deep Agent)** decouples planning from execution, manages memory externally, and delegates work to specialized sub-agents. It does not just react — it plans, delegates, remembers, and recovers.

> [!quote] Philipp Schmid
> "Moving from Shallow Agents to Deep Agents isn't just about connecting an LLM to more tools. It is a shift from reactive loops to proactive architecture. It is about better engineering around the model."

## Why Shallow Agents Break

A shallow agent asked to *"Research 10 competitors, analyze pricing, build a comparison, write a summary"* fails for three reasons:

| Failure Mode | What Happens |
|---|---|
| **Context Overflow** | Tool outputs (HTML, raw data) fill the window, pushing instructions out |
| **Loss of Goal** | Amidst step noise, the agent forgets the original objective |
| **No Recovery** | If it goes down a rabbit hole, it has no mechanism to stop, backtrack, and retry |

Shallow agents are great at 5–15 steps. They fail at 500.

## The Four Pillars of Agent 2.0

### Pillar 1 — Explicit Planning

Shallow agents plan implicitly via chain-of-thought ("I should do X, then Y"). Deep agents use tools to create and maintain an **explicit plan** — typically a to-do list in a markdown document.

Between every step, the agent reviews and updates this plan, marking steps `pending`, `in_progress`, or `completed`. If a step fails, it updates the plan to accommodate the failure rather than retrying blindly.

> [!tip]
> This is what keeps the agent focused on the high-level task while executing low-level tool calls. The plan is external state — it survives context compaction.

### Pillar 2 — Hierarchical Delegation (Sub-Agents)

Complex tasks require specialization. Shallow agents try to be a jack-of-all-trades in one prompt. Deep agents use an **Orchestrator → Sub-Agent** pattern.

```
Orchestrator: receives task, creates plan, delegates
    ↓
Sub-Agent "Researcher": search loop, returns synthesized answer only
Sub-Agent "Coder": implementation loop, returns working code only
Sub-Agent "Writer": drafts based on researcher output, returns final doc
    ↓
Orchestrator: compiles, reviews, delivers
```

The sub-agent returns *only* the synthesized answer to the orchestrator — not the raw tool call history. This is the key: **result isolation keeps the orchestrator's context clean.**

See [[subagent-patterns]] for the four canonical patterns.

### Pillar 3 — Persistent Memory

To prevent context overflow, deep agents treat the **filesystem or vector database as external memory**, not the context window.

- Frameworks like Claude Code and Manus give agents `read`/`write` access to persistent storage
- Intermediate results (code, draft text, raw data) are written to files
- Subsequent agents reference file paths or queries to retrieve only what's necessary
- Paradigm shift: "remembering everything" → "knowing where to find information"

See [[context-engineering]] for the strategies that make this work.

### Pillar 4 — Extreme Context Engineering

Smarter models don't require less prompting — they require **better context**. A system prompt that says "You are a helpful AI" will not produce Agent 2.0 behavior.

Deep agents rely on highly detailed instructions (sometimes thousands of tokens) that define:

- When to stop and plan before acting
- Protocols for spawning a sub-agent vs. doing the work themselves
- Tool definitions and examples of how and when to use them
- Standards for file naming and directory structure
- Formats for human-in-the-loop collaboration checkpoints

> [!warning] The AGENTS.md research finding
> Auto-generated AGENTS.md files reduce task success by ~3% while increasing cost 20%+. Human-written files improve performance only ~4%, and still increase cost 19%. Every line goes into every session — make each one count. Keep it under 300 lines; point to external docs rather than embedding content.

See [[context-engineering]] and [[agent-harness]] for implementation.

## Agent 1.0 vs Agent 2.0 Comparison

| Dimension | Agent 1.0 (Shallow) | Agent 2.0 (Deep) |
|---|---|---|
| **State** | Context window only | External memory + context |
| **Planning** | Implicit (chain-of-thought) | Explicit (plan document, updated per step) |
| **Specialization** | One jack-of-all-trades prompt | Orchestrator + specialist sub-agents |
| **Failure handling** | Retry or crash | Update plan, backtrack, try alternative |
| **Context management** | Grows until overflow | Controlled: write to files, retrieve on demand |
| **Task length** | 5–15 steps | Hundreds of steps, hours to days |
| **Recovery** | None | Plan update + sub-agent relaunch |

## Example: Deep Agent Flow

For a request like *"Research quantum computing and write a summary to a file"*:

```
1. Orchestrator reads task, creates plan.md
   plan.md: [ ] search quantum computing, [ ] extract key themes, [ ] write summary

2. Orchestrator spawns Researcher sub-agent
   → Researcher: 5-10 search/read cycles
   → Returns: synthesized 500-word summary (not raw search dumps)
   → Orchestrator: marks step 1 complete in plan.md

3. Orchestrator spawns Writer sub-agent
   → Writer: reads researcher output from filesystem
   → Returns: formatted markdown document
   → Orchestrator: marks step 2 complete

4. Orchestrator writes final file, verifies it exists
   → Task complete; returns clean result to user
```

The orchestrator's context never sees the raw search results. Only compiled, synthesized outputs flow up the chain.

## Connection to the Broader Landscape

The Agent 2.0 architecture is what makes [[automated-research]] possible — the autoresearch loop is essentially a specialized deep agent operating autonomously over ML experiments. The same four pillars apply: explicit plan (experiment log), hierarchical delegation (run subprocess), persistent memory (git history), and extreme context engineering (training script + metric + constraints).

The [[agent-harness]] is what implements these four pillars in practice. The harness *is* the Agent 2.0 infrastructure.

## See Also
- [[subagent-patterns]] — Pillar 2 in detail: four canonical delegation patterns
- [[context-engineering]] — Pillars 3 and 4: memory strategies and context control
- [[agent-memory]] — Pillar 3 in depth: file-system memory, Dreaming, multi-agent scopes
- [[agent-harness]] — the infrastructure layer that enables deep agent behavior
- [[agent-engineering]] — why the shift to probabilistic, planning-based systems requires a different engineering mindset
- [[closing-the-loop]] — how deep agents verify their own work
