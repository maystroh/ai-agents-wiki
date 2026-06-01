---
title: "Subagent Patterns (2026)"
author: Philipp Schmid
date: 2026-05-05
url: https://www.philschmid.de/subagent-patterns-2026
tags:
  - philschmid
  - subagents
  - architecture
  - patterns
---

# Subagent Patterns (2026)

## Summary

- Catalogs four canonical subagent patterns with when-to-use guidance
- Pattern 1: Inline Tool — single agent, multiple tools, sequential or parallel tool calls within one context
- Pattern 2: Fan-Out — orchestrator spawns N parallel subagents, collects results, synthesizes
- Pattern 3: Agent Pool — orchestrator delegates to a pool of identical agents; used for homogeneous parallelism
- Pattern 4: Teams — specialized agents (researcher, coder, reviewer) with defined handoff protocols
- Introduces the escalation rule: always try inline first, escalate to subagents only when context budget, parallelism, or specialization demands it

## Key Insights

- **Context isolation is the core value proposition of subagents.** Not parallelism — isolation. A subagent with a clean 8k context outperforms a bloated 200k primary on focused tasks.
- **Fan-out collects results differently than teams.** Fan-out: all results return to orchestrator for final synthesis. Teams: results chain sequentially (researcher → coder → reviewer).
- **Agent Pool requires homogeneous tasks.** Don't use a pool if agents need different specializations — use Teams instead.
- **The escalation rule prevents over-engineering.** Most tasks that "seem to need subagents" work fine as inline tool calls once the system prompt is well-written.
- **Result isolation protocol.** Subagents must return synthesized results, not raw tool history. This is what keeps the orchestrator's context manageable.

## Concepts Touched

- [[subagent-patterns]] — full concept page
- [[agents-evolution]] — Pillar 2 (hierarchical delegation)
- [[context-engineering]] — isolation as a strategy
- [[agent-harness]] — subagent topology as a harness component

## Notable Quotes

> "Context isolation is the core value proposition, not parallelism. A subagent with clean 8k context outperforms a bloated 200k primary on focused tasks."
