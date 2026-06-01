---
title: "Tool, Skill, or Subagent: Decomposing an Agent That Outgrew Its Prompt"
author: Will (Anthropic, Applied AI)
date: 2026-05-27
url: https://www.youtube.com/watch?v=mWvtOHlZM-I
tags:
  - agent-engineering
  - skills
  - subagents
  - tools
  - evals
  - managed-agents
  - decomposition
  - anthropic
sources: tool-skill-subagent-decomposition
updated: 2026-05-28
---

# Tool, Skill, or Subagent: Decomposing an Agent That Outgrew Its Prompt

## Summary

- A common pattern: an agent ships, works well, receives business requirements over time, and accumulates complexity until eval performance degrades — the "agent that outgrew its prompt."
- The solution is architectural modernization using the right agentic primitives: **tools** for actions, **skills** for conditional domain knowledge (progressive disclosure), **subagents** for parallelism or fresh perspective.
- Demonstrated on **StockPilot** (inventory management agent): 400-line system prompt + 12 tools + 3 subagent wrappers → 15-line system prompt + 3 tools (bash/read/write) + 1 managed subagent; eval score improved from 62% to 92%.
- The **tool hierarchy**: start with humanlike primitives (code execution, file system, web search, todo list) → add custom agent-specific tools → use MCP only when multiple agents/clients need shared standardized tooling.
- **Subagents** are justified in two specific cases: (1) throwing a lot of Claude at a problem in parallel, or (2) getting a fresh perspective on work done by a different Claude instance.

## Key Insights

### The Bloated Agent Pattern

The failure mode is universally recognizable:

1. Agent ships solving a specific problem well
2. Business requirements arrive → add capability
3. Requirements arrive again → add more capability
4. System prompt grows to hundreds of lines
5. Tools proliferate (12+)
6. Sub-agents get bolted on as tool wrappers
7. Eval scores start to dip

The three eval failures in StockPilot illustrate the pathology:
- **F1 (winding path):** Agent reaches the right answer but takes an inefficient route — too many competing paths in a bloated system prompt
- **F2 (communication breakdown):** Subagent gets the task right but miscommunicates results to orchestrator — a common failure point for multi-agent systems
- **R8 (contradicting policies):** Two policies in different sections of the system prompt contradict each other; agent hallucinates the wrong value

### Skills as Progressive Disclosure (System Prompt Relief Valve)

The fix for R8 (contradicting policies in system prompt) is to move business logic out of the system prompt and into skills.

**Principle:** The system prompt should contain only what Claude needs in its mind *regardless of the task*. Everything else — policies, procedures, domain rules — belongs in skills that load conditionally.

Before → After:
- System prompt: 400 lines → 15 lines
- Business logic: inline → Skills (loaded on demand when Claude recognizes it needs them)

> "Leave the system prompt only for the information Claude needs regardless of the task. Skills are fantastic for packaging information Claude is going to need *some* of the time, not *all* of the time."

This prevents context pollution: stacking all possible information in the system prompt ensures Claude sees irrelevant information on every call, increasing cost and degrading reasoning.

### Tool Hierarchy: Start with Humanlike Primitives

Anthropic's internal guidance on tool design:

1. **Start with primitives** — code execution, file system navigation, web search, todo list. These are what you and I have when we show up to work. Claude reasons across the same primitives.
2. **Remove what you don't need** — not every agent needs web search; remove tools that don't apply to the domain.
3. **Add custom tools** — only when primitives can't cover the use case.
4. **MCP last** — only when multiple agents or clients need access to a shared, standardized, governed set of tools.

> "We always start with those Claude Code primitives, those humanlike primitives, and then add custom tools only as we need them."

MCP anti-pattern observed with customers: rushing to MCP first, ending up with a chaotic ecosystem of overlapping MCP servers that pollute context.

### Code Execution Beats CSV-in-Context

One of the most impactful changes in StockPilot: instead of loading CSV files into Claude's context window, give Claude a bash tool to write and run Python scripts that reason across the data.

Result: **200,000+ tokens → dramatically fewer tokens** for a task requiring analysis across inventory spreadsheets. Claude writes a script, runs it, reads the results — rather than consuming all the raw data in one context. Costs and latency drop proportionally.

### When to Use Subagents

Two and only two strong cases:

1. **Parallelism / scale** — throw a lot of Claude at a big problem simultaneously (deep research, codebase exploration, fan-out document analysis)
2. **Fresh perspective** — one Claude instance shouldn't both write and review its own work; a second instance with no context from the first is better positioned to critique

> "Frontier models have gotten intelligent enough to manage across more information where you just don't need as many sub-agents."

Many subagents that existed in legacy systems can be collapsed back into the main agent — model capability growth reduces the need for architectural complexity.

### CMA Callable Agents vs Tool-Wrapped Subagents

Old pattern: subagent defined as a tool — orchestrator calls the tool, tool spins up subagent, returns result. Observability is poor; you must collect transcripts from multiple independent systems.

New pattern (Claude Managed Agents): **callable agents** with native CMA subagent support. Session logging and observability are unified — the subagent's activity is traceable within the same session view as the orchestrator. This resolves the communication breakdown failure mode.

### Hill-Climbing on Evals

The eval-driven improvement cycle:

```
run evals (baseline: 62%)
    ↓
use Claude Code to triage: what are the failure themes?
    (tool gaps, output structure enforcement, policy conflicts)
    ↓
address issues one by one:
    - skills to replace system prompt sections
    - humanlike primitives to replace custom tools
    - fix/remove misused subagents
    ↓
rerun targeted evals
    ↓
confirm improvement (92%)
```

Using Claude Code with Opus 4.7 at "extra high effort" to triage eval failures is itself part of the workflow — Claude analyzes the results and identifies root causes before you make changes.

### Agent Decomposition Decision Framework

| Scenario | Use |
|---|---|
| Claude needs information sometimes, not always | **Skill** |
| Claude needs to perform an action | **Tool** |
| Information always needed regardless of task | **System prompt** |
| Big problem that benefits from parallelism | **Subagent** |
| Need a fresh perspective / writer-reviewer separation | **Subagent** |
| Multiple agents / clients need shared standardized tools | **MCP** |

## Concepts Touched

- [[agent-skills]] — progressive disclosure; system prompt relief valve; 400-line → 15-line example
- [[subagent-patterns]] — when to use subagents (two cases); callable agents in CMA
- [[mcp-servers]] — tool hierarchy; MCP last, not first; code execution as MCP alternative
- [[agent-harness]] — managed agents as decomposition platform; callable agents for observability
- [[evals-and-graders]] — hill-climbing; LLM-as-judge; using Claude to triage eval failures
- [[context-engineering]] — code execution vs CSV in context; context pollution from bloated system prompt

## Notable Quotes

> "Leave the system prompt only for the information that Claude needs in its mind, regardless of the task that you give it. Skills are fantastic for packaging information Claude is going to need some of the time, not all of the time."

> "Frontier models have gotten intelligent enough to manage across more information where you just don't need as many sub-agents."

> "We always start with those humanlike primitives — code execution, file system navigation, web search — then build accordingly."

> "We don't run to MCP. Only in the case where we have a common collection of tools that multiple clients will benefit from accessing do we go about collecting those and publishing them as an MCP server."
