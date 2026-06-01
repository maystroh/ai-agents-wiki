---
title: Agent Harness
tags: [harness, infrastructure, core-concept]
sources: [agent-harness-2026, hidden-debt-harness, components-coding-agent, context-engineering-part2, yc-chief-codes-10000-lines, ship-first-managed-agent, trustworthy-agentic-dsl, tool-skill-subagent-decomposition]
updated: 2026-05-28
---

# Agent Harness

## Definition

The **agent harness** is the orchestration layer that sits between an LLM and the environment it operates in. It is not the agent itself (the model + its reasoning), nor is it a framework (which provides building blocks). It is the system that *governs* how the agent operates.

Components of a harness:
- **System prompt / persona** — standing instructions that bias behavior across every turn
- **Tool surface** — callable functions, schemas, descriptions, examples
- **Rollout protocol** — the shape of the loop (single-turn, ReAct, plan-and-execute, multi-agent)
- **Context manager** — what carries across turns, what gets compacted or dropped
- **Memory** — short-term scratchpad, mid-term progress files, long-term retrieval stores
- **Sub-agent topology** — orchestrator, workers, judges, hand-off protocols
- **Guardrails and gates** — input/output filters, action allowlists, approval tiers
- **Verifiers and judges** — step success detection, plan continuation logic
- **Observability** — traces, replay, eval hooks

**Analogy:** Model = CPU. Context window = RAM. Harness = Operating System. Agent application = the user-level process.

## Why It Matters

A powerful model running in a weak harness underperforms. The reverse is also true: third-party harnesses that invest heavily in axes the first-party harness underweights can outperform it. **Letta Code** beats **Claude Code** on Opus 4.5 (59.1% vs 41.6% on a coding benchmark) by building a rich memory substrate — a dimension Claude Code intentionally keeps thin.

Conversely, **first-party harnesses** (Claude Code, Codex) usually outperform third-party ones because the model is post-trained against that specific harness's tool schemas, loop shape, and context layout. Dropping Claude into a generic ReAct wrapper runs it out of distribution.

## Inner vs Outer Harness

(From Böckeler's harness engineering article)

- **Inner harness**: what the model builder ships — Anthropic's Claude Agent SDK, Cursor's Auto, Codex's app server. Evolves with model releases.
- **Outer harness**: what the *user* assembles on top — AGENTS.md, MCP servers, custom skills, org-specific code review agents. Evolves with the team's workflow.

Both accumulate debt, on different clocks.

## The Bitter Lesson Applied to Harnesses

Rich Sutton's Bitter Lesson: general methods + compute beat hand-coded intelligence over time. This applies directly to harnesses.

- 2023 harnesses: held the entire memory layer (chunkers, embedders, vector stores, rerankers) because models had tiny context windows
- 2024 harnesses: explicit planner-executor workflows because tool calling was unreliable
- 2025–2026: models call tools, interleave planning and action, have long contexts — so RAG pipelines, planner-executor splits, and multi-layer memory stacks are dissolving into the model

LangChain rewrote open-deep-research 4 times. Manus rewrote their harness 5 times. This is normal — not dysfunction. **Build to delete.**

## Production Harness vs Training Harness

| Dimension | Training/Research | Production |
|---|---|---|
| Action space | Maximal | Minimal (explicit allowlist) |
| Tools | Raw, low-level, extensible | Wrapped, scoped, versioned |
| Failures | Welcome (signal for optimizer) | Suppressed (retry, fail closed) |
| Guardrails | KL caps, reward shaping | RBAC, action gates, output filters |
| State | Forkable, snapshottable | Durable, per-user, auditable |

A production harness should be **narrow by design**. A training harness should be **wide by design**. Shipping a training harness to production (or vice versa) is a category error that leads to incidents.

## Three Optimization Surfaces

| Surface | Cost to change | Cadence | Owned by |
|---|---|---|---|
| Skills / prompts | Cheap (text edits) | Hourly–daily | Product builders |
| Harness | Medium (code, ships with binary) | Daily–weekly | Research engineers |
| Model | Expensive (post-training compute) | Quarterly (lab-side) | Research labs |

**Principle**: push work to the cheapest surface. Keep the harness thin. Put domain expertise in skills. Let the lab own the model.

## Fat Harness Anti-Patterns

The explicit failure modes of an over-engineered harness (from Garry Tan's framework, confirmed by Claude Code source analysis):

- **Tool count bloat** — 40+ tool definitions eating half the context window. Each tool definition costs index tokens; the harness crowds out the task.
- **God-tools via MCP** — single MCP tools with multi-second round-trips that block the agent loop. MCP server calls should be scoped and fast, not a synchronous black box.
- **REST API wrappers** — turning every API endpoint into a separate tool. The model spends context learning a private abstraction layer instead of composing primitives.
- **Inline context documents** — embedding full documents in the system prompt rather than using resolvers to load them on demand. Garry Tan reduced his CLAUDE.md from 20,000 lines to ~200 by switching to pointer-based loading.

The Claude Code source (leaked March 2026, 1,906 files) confirmed disciplined narrow tooling throughout — consistent with the thin harness discipline.

## Resolver Pattern

A **resolver** is a routing table for context: when task type X appears, load document Y. Instead of pre-loading all relevant context, the harness matches user intent to skill/document descriptions and loads only what's needed.

Claude Code's embedded resolver matches user intent to skill descriptions automatically. This is the mechanism behind progressive disclosure in [[agent-skills]] — the skill index stays small, and the full skill body loads only when the resolver fires.

**Effect:** Garry Tan's CLAUDE.md went from 20,000 lines to ~200 lines of pointers. The content didn't shrink — the loading strategy changed.

## The Self-Healing Harness

Browser Use's approach: most of the harness is code the agent can edit at runtime, plus a SKILL.md telling it how. When a helper function is missing, the agent writes it. The harness becomes a starting point, not a frozen surface.

The Claude Code source confirms this pattern at scale: a self-healing query loop, background memory daemon (autoDream), concurrency-safe tool batching, and compile-time feature gating — all with the model at the center.

## Managed Agent Harness: Brain/Hands Decoupling

Claude Managed Agents (Anthropic, 2026) introduces a production harness design principle not present in earlier frameworks: **explicitly separating the agent loop (brain) from tool execution (hands)**.

**Previous pattern (coupled):** Agent loop + tool execution run in the same container. Every session spins up a container with all tools installed. Common in Claude Code, Codex, and most open-source frameworks.

**Managed Agents pattern (decoupled):**
- **Brain (agent loop):** Runs server-side on Anthropic infrastructure. Persistent, durable, state maintained via event log. Continues if client disconnects.
- **Hands (tool execution):** Runs in a separate environment — Anthropic's sandbox by default, or BYOC (bring your own compute, released May 2026). Pre-warmed, independent of the agent loop.

**Measured benefits of decoupling:**
1. **Security:** Credentials live in encrypted vaults, never co-located with the inference container. Separating hands from brain prevents the agent from accessing credentials without explicit encryption.
2. **Latency:** Environments can be pre-warmed rather than spun up per session. Result: >90% reduction in P95 TTFT (time to first token).
3. **Reliability:** If the execution container crashes, only that container restarts — the agent loop (event log) continues from where it left off.

**Event log as durability primitive.** Sessions work in events (user messages, tool calls, tool results, agent responses), not token in/out. The event log is the durable state. Closing your browser, losing a container, or disconnecting doesn't restart the agent — it resumes from the last event.

**Harness maintenance cost.** Managed Agents abstracts away the ongoing maintenance of harness primitives (compaction, caching, context management). Example from Anthropic: Sonnet 4.5 introduced "context anxiety" (early task termination with remaining context) — they added harness mitigations. When Opus 4.5 fixed the behavior natively, all that harness work became obsolete. Managed Agents absorbs this churn automatically.

## DSL-Based Verifiable Harness

An alternative harness design for high-trust, high-rigor domains: replace natural language agent loops with an **executable domain-specific language (DSL)**.

**Problem:** Natural language plans are neither legible nor reliably executed. An agent that generates a research plan in prose may or may not follow it — there is no formal guarantee of faithfulness. Each iteration on the plan can drift from the original intent.

**Elicit's AshPL approach** (James Brady, 2026): The harness compiles agent intentions into AshPL, a Turing-incomplete, purely functional subset of Python with domain primitives for scientific research. The plan *is* the program — it is executable, inspectable, and version-controlled.

Key properties of a DSL-based harness:
- **Legibility** — the plan is readable by humans and by critique agents, which can check for missed steps
- **Iteration fidelity** — adding layers to the plan doesn't cause the agent to lose track of what it was doing; the whole program is re-executed from top each cycle (with memoization)
- **Faithful execution** — the system literally cannot do something other than what the DSL specifies

**Write → interpret → redraft loop:**
```
curator (LLM) writes DSL program
    ↓
Python service validates syntax + type checks
    → type errors: cheap correction cycle
    ↓
Python service interprets AST
    → content-address store: memoize all previously computed expressions
    ↓
curator drafts extended program (adds steps)
    → whole program reinterpreted; majority cached
```

**Engineering reality:** The DSL itself is a small fraction of the work. The engineering effort goes into: harness/model switching wrapper, interrupt handling, session rehydration, credential isolation, message routing, and a dedicated eval team.

**When to reach for a DSL:** Only when your product's trust model specifically demands legibility, iteration fidelity, and faithful plan execution — typically high-stakes domains (scientific research, legal analysis, clinical decisions). Most products do not need this.

> "A table in Elicit is a fundamentally different thing to a table that's just been burbled out from a model." — James Brady (Elicit)

## See Also
- [[agent-skills]] — the cheapest optimization surface
- [[context-engineering]] — what the harness does to manage context
- [[agent-runtime]] — the infrastructure the harness runs on
- [[subagent-patterns]] — how harnesses orchestrate multiple agents
- [[inner-outer-loop]] — inner/outer loop behavior the harness enables
- [[agents-evolution]] — how harnesses evolved from Agents 1.0 to 2.0
- [[evals-and-graders]] — eval hooks are a key harness component
