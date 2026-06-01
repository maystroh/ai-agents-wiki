---
title: "Memory and Dreaming for Self-Learning Agents"
author: "Ravi (Anthropic API Knowledge Team)"
date: 2026-05-22
url: https://www.youtube.com/watch?v=IGo225tfF2I
tags:
  - memory
  - dreaming
  - managed-agents
  - outer-loop
  - multi-agent
  - anthropic
  - self-learning
  - ai-agents
sources:
  - "AI Agents/Claude/2026-05-22"
updated: 2026-05-24
---

# Memory and Dreaming for Self-Learning Agents

## Summary

- Anthropic's API knowledge team describes "Memory" and "Dreaming" as two components of Managed Agents — Anthropic's hosted agent infrastructure
- Memory is file-system based: Claude navigates it natively, treating files as persistent external state across sessions
- Dreaming is an out-of-band background process that analyzes cross-session transcripts and globally optimizes memory — agents "dream" about past experiences to consolidate learnings
- Production results: Racketin (legal tech) saw 97% decrease in first-pass errors; Harvey saw 6× completion rate improvement
- Multi-agent memory has read-only (org-wide) and read-write (agent-local) scopes; version history and attribution track changes

## Key Insights

- **Memory = file system, not a vector database.** Instead of treating memory as embeddings to retrieve, Anthropic's approach gives agents a writable filesystem and lets Claude navigate it using its native file-manipulation capabilities. This leverages Claude's training directly rather than adding a retrieval layer.
- **Dreaming = async transcript distillation.** Between sessions, a background process reads accumulated conversation transcripts and updates the memory store — pruning, consolidating, and promoting learnings to global scope. Agents effectively "sleep and dream" to extract lessons from experience.
- **The outer loop is automated.** Dreaming is the mechanism that closes the outer loop without human intervention. This is the infrastructure equivalent of what Eugene Yan describes as "mine failure transcripts to update skills."
- **Multi-agent memory scoping.** Memory has two scopes: read-only org-wide memory (shared across agents) and read-write agent-local memory. Optimistic concurrency control prevents write conflicts. Version history provides attribution for memory updates.
- **Racketin 97% / Harvey 6×.** These production numbers make the case that automated memory optimization is not incremental — it's a qualitative shift in agent reliability.
- **The "dreaming" metaphor is functional, not poetic.** It directly maps to the technical architecture: offline, async, cross-session analysis that updates global state.

## Concepts Touched

- [[concepts/inner-outer-loop]] — Dreaming is the automated outer loop mechanism
- [[concepts/agent-runtime]] — Managed Agents as hosted agent infrastructure
- [[concepts/context-engineering]] — memory navigation as a context management strategy
- [[concepts/automated-research]] — transcript analysis as a form of self-directed research
- [[entities/tools-products]] — Memory + Dreaming as a product feature

## Notable Quotes

> "Dreaming is an out-of-band process that reads your transcripts from the past week and globally optimizes your memory."

> "Racketin saw a 97% decrease in first-pass errors after enabling memory. Harvey saw 6× improvement in completion rate."

> "Memory is just a file system. Claude already knows how to navigate files — we didn't need to invent a new abstraction."

> "Multi-agent memory has read-only org-wide scope and read-write agent-local scope with version history and attribution."
