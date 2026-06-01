---
title: "Agents 2.0: From Shallow Loops to Deep Agents"
author: Philipp Schmid
date: 2025-10-12
url: https://www.philschmid.de/agents-2.0-deep-agents
tags:
  - philschmid
  - agents-evolution
  - deep-agents
  - architecture
---

# Agents 2.0: From Shallow Loops to Deep Agents

## Summary

- Introduces the architectural shift from **Shallow Agents (1.0)** — a simple while-loop over context — to **Deep Agents (2.0)** — systems that plan, delegate, and remember across extended tasks
- Shallow agents fail at tasks requiring 50+ steps due to context overflow, loss of goal, and no recovery mechanism
- Deep agents are defined by four pillars: Explicit Planning, Hierarchical Delegation, Persistent Memory, Extreme Context Engineering
- The term "Deep Agents" was popularized by the LangChain team
- Frameworks like Claude Code and Manus are cited as examples of agents with persistent filesystem access

## Key Insights

- **Shallow agents are great at 5–15 steps; they fail at 500.** The context window is both their entire brain and their bottleneck.
- **Explicit planning = external state.** A to-do list in a markdown file, updated after every step, is what prevents goal drift in long tasks.
- **Sub-agents return synthesized results, not raw history.** The orchestrator never sees tool call dumps — only compiled answers. This keeps the orchestrator context manageable.
- **Context engineering is not optional.** "You are a helpful AI" will not produce Agent 2.0 behavior. The system prompt must define when to plan, when to spawn, how to name files, and what checkpoints require human input.

## Concepts Touched

- [[agents-evolution]] — the core thesis of this piece
- [[subagent-patterns]] — Pillar 2 (hierarchical delegation)
- [[context-engineering]] — Pillars 3 and 4
- [[agent-harness]] — the infrastructure that enables the four pillars

## Notable Quotes

> "Moving from Shallow Agents to Deep Agents isn't just about connecting an LLM to more tools. It is a shift from reactive loops to proactive architecture. It is about better engineering around the model."

> "By controlling the context, we control the complexity, unlocking the ability to solve problems that take hours or days, not just seconds."
