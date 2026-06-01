---
title: Context Engineering
tags:
  - context-engineering
  - core-concept
  - performance
aliases:
  - Context Management
  - Context Rot
sources:
  - context-engineering-part2
  - agent-harness-2026
  - components-coding-agent
  - why-engineers-struggle
updated: 2026-05-27
---

# Context Engineering

## Definition

**Context Engineering** is the discipline of designing a system that provides the right information and tools, in the right format, to give an LLM everything it needs to accomplish a task.

> [!quote]
> "Context Engineering is not about adding more context. It is about finding the minimal effective context required for the next step." — Philipp Schmid

It is not a feature of the model — it is the job of the [[agent-harness]].

## Key Failure Modes

### Context Rot
Performance degrades as the context window fills up, even when the total token count is well within the technical limit. The **effective context window** (where the model performs at high quality) is typically much smaller than the advertised limit. For most 2025–2026 models: **< 256k tokens** is the practical high-quality zone, even with 1M+ advertised contexts.

### Context Pollution
Too much irrelevant, redundant, or conflicting information distracts the model and degrades reasoning accuracy. A long tool output from 10 turns ago that's still in context is pollution.

### Context Confusion
The model can't distinguish between instructions, data, and structural markers — or encounters logically incompatible directives (system instructions clash with user instructions, or with each other).

## The Four Strategies

### 1. Context Offloading (Compaction — Reversible)
Strip out information that is redundant because it already exists in the environment. Compaction is **reversible**: if the agent needs the content later, it can re-read it via a tool call.

> [!example]
> If an agent writes a 500-line code file, the chat history should not contain the file content. It should contain only the file path: `Output saved to /src/main.py`.

### 2. Context Reduction (Summarization — Lossy)
Use an LLM to summarize the history at a **pre-rot threshold** (e.g., when context exceeds 128k tokens). Manus keeps the most recent tool calls in raw, full-detail format while summarizing older turns. This preserves the model's "rhythm" — formatting style and output quality continuity.

> [!tip] Prefer raw → compaction → summarization
> Summarize only when compaction no longer yields enough space. Summarization is lossy; use it as a last resort within the turn budget.

### 3. Context Retrieval (Dynamic Context)
Add information into context on demand, only when needed. This includes:
- Skill bodies loaded when a skill triggers ([[agent-skills]])
- Reference files loaded when a sub-condition is met ("Read `api-errors.md` if API returns non-200")
- Sub-agent results injected when the main agent calls `wait_agent`

> [!warning] Don't use RAG for tool definitions
> Fetching tool definitions dynamically per step breaks the KV cache and confuses the model with "hallucinated" tools that appear and disappear. Stable tool surfaces belong in the stable prompt prefix.

### 4. Context Isolation (Sub-agents)
Spin up fresh sub-agents with their own context for discrete tasks. This prevents the main agent's accumulated history from contaminating fresh reasoning.

> [!quote] GoLang applied to agents
> "Share memory by communicating, don't communicate by sharing memory." — Manus

Only share full memory/context history when the sub-agent *must* understand the full trajectory (e.g., a debugging agent that needs to see all previous error attempts). Forking context breaks the KV cache — treat it as an expensive dependency to minimize.

## Hierarchical Tool Surface

Providing an LLM with 100+ tools leads to Context Confusion. Manus solves this with a three-level hierarchy:

| Level | Content | Strategy |
|---|---|---|
| **L1 Atomic** | ~20 core tools (`file_write`, `browser_navigate`, `bash`, `search`) | Stable, cache-friendly |
| **L2 Sandbox** | CLI utilities (grep, ffmpeg, etc.) | Instruct agent to use `bash` to call them |
| **L3 Code/Packages** | Complex multi-step logic chains | Provide libraries; let agent write a script |

For logic chains like "Fetch city → Get ID → Get Weather," don't make 3 LLM roundtrips. Provide a library function and let the agent call it once.

## Prompt Shape and Cache Reuse

Smart runtimes separate the prompt into layers:

```
┌─────────────────────────────┐
│  Stable prefix              │ ← System prompt, tool defs, workspace summary
│  (rarely changes — cached)  │   Rebuilt only when something structural changes
├─────────────────────────────┤
│  Session state              │ ← Short-term memory, recent transcript
│  (updated each turn)        │   Compact version of recent history
├─────────────────────────────┤
│  Current request            │ ← This turn's user message
└─────────────────────────────┘
```

The stable prefix gets KV-cached across turns. Rebuilding it from scratch on every turn is wasteful — and breaks the cache.

## Pre-Rot Threshold

Define a threshold **before** the rot zone hits, not after:

- Model advertises: 1M token context
- Practical high-quality zone: < 256k tokens
- Pre-rot threshold trigger: at ~128k tokens, start compaction

Waiting for the API to error is too late. Monitor token count actively and trigger compaction before quality degrades.

## Agent-as-Tool (MapReduce Pattern)

Don't over-anthropomorphize agents. Instead of an "Org Chart" of agents (Manager, Designer, Coder) that chat with each other, treat agents as tools.

```
main agent → calls call_planner(goal="...") 
           → harness spins up temp sub-agent loop 
           → returns structured result (e.g., JSON plan object)
```

The sub-agent is exactly like a deterministic code function: the main agent defines the goal, tools, and output schema. The result is instantly usable without further parsing.

## The KV Cache Constraint (Why You Can't Evict Mid-Prompt)

The KV cache fundamentally changes how you should structure system prompts — not just as a performance optimization, but as a hard architectural constraint.

**The core problem:** If you change anything in the early part of the prompt, you invalidate cached tokens for *everything that follows*. Uncached tokens cost ~10× more than cached tokens. This means:

1. You cannot "evict" a tool from the middle of the tool block without paying full uncached cost for all tokens after it
2. The LRU-cache intuition (evict least-recently-used tools to save space) doesn't apply — the eviction itself is expensive
3. Dynamic tool surfaces (fetching schemas per step based on current intent) break cache continuity

**The correct structure:**

```
┌────────────────────────────────────┐
│  STABLE (cached, rarely changes)   │  ← System prompt, core tool schemas,
│                                    │    workspace summary, shared context
├────────────────────────────────────┤
│  VOLATILE (per-task, end of prompt)│  ← Task-specific context, recent
│                                    │    transcript, per-request instructions
└────────────────────────────────────┘
```

Stable content goes first and stays there. Volatile content goes last so you can update it without invalidating the stable cache. This is the opposite of intuition: you might think task-specific context belongs near the instructions, but cache economics demand otherwise.

> [!warning] Context windows aren't growing — but models are improving
> As of 2026, frontier models have ~1M token context windows — roughly unchanged for over a year — while model quality has improved substantially. The fixed context target makes efficient placement more important, not less.

**Practical rules:**
- Core tools and system prompt text: always at the front, never reordered
- Stable task-class information (e.g., "this is a Python codebase"): stable prefix
- User-specific or turn-specific context: end of prompt, replaceable without cache invalidation
- Don't use dynamic tool eviction — the savings aren't real once you count uncached token cost

## See Also
- [[agent-harness]] — implements context engineering strategies
- [[agent-skills]] — progressive disclosure as a context retrieval technique
- [[subagent-patterns]] — context isolation via sub-agents
- [[inner-outer-loop]] — context management within tasks vs across sessions
