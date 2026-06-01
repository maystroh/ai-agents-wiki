---
title: "Context Engineering Part 2"
author: Philipp Schmid
date: 2025-12-04
url: https://www.philschmid.de/context-engineering-part-2
tags:
  - philschmid
  - context-engineering
  - architecture
---

# Context Engineering Part 2

## Summary

- Defines context engineering as finding the minimal effective context: enough signal for the task, no more
- Identifies four failure modes: Context Rot, Pollution, Confusion, and Distraction
- Presents four strategies: Offloading (compaction/reversible), Reduction (summarization/lossy), Retrieval (dynamic injection), Isolation (subagents with clean slates)
- Introduces the Hierarchical Tool Surface concept: three levels of tool disclosure matched to the task

## Key Insights

- **Effective window is ~<256k even for 1M-token models.** Performance degrades as context fills; the pre-rot threshold is the point at which degradation starts for a given model+task.
- **Compaction vs summarization.** Compaction (trim redundant scaffolding, move completed work to files) is reversible. Summarization is lossy — use it only when necessary.
- **Hierarchical Tool Surface.** Level 1: always-available core tools (~5). Level 2: domain-specific tools loaded per task (~20). Level 3: capability tools injected per-call when needed.
- **Prompt shape matters for caching.** Static system prompt first, then read-only context, then dynamic task input. Reordering breaks the KV cache and doubles cost on long-horizon tasks.
- **Isolation via subagents.** Spawning a subagent with only the relevant slice of context is often cheaper than managing a bloated primary context.

## Concepts Touched

- [[context-engineering]] — the full treatment
- [[agent-harness]] — where context strategies are implemented
- [[subagent-patterns]] — isolation as a strategy

## Notable Quotes

> "Context engineering is not about stuffing the window — it's about finding the minimal effective context: enough signal for the task, no more."
