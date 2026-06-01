---
title: "Building the Best Agentic Analytics Harness: Powered by Claude, Built with Claude Code"
author: "Omni CTO (anonymous)"
date: 2026-05-22
url: https://www.youtube.com/watch?v=K4-flzsPraE
tags:
  - agent-harness
  - analytics
  - production
  - error-recovery
  - consolidate-the-brain
  - sql
  - ai-agents
sources:
  - "AI Agents/Claude/2026-05-22"
updated: 2026-05-24
---

# Building the Best Agentic Analytics Harness: Powered by Claude, Built with Claude Code

## Summary

- Omni (25-engineer company) built "Blobby," an agentic analytics assistant, over 18 months — a detailed production case study in harness design
- Error recovery is the single highest-leverage improvement: agents that catch and recover from errors dramatically outperform agents that don't
- "Consolidate the brain": don't split orchestrator/sub-agent when the outer agent can't predict what a single query can handle
- Switching from a proprietary JSON query format to SQL eliminated a class of context confusion errors and reduced hallucinations
- The team uses Claude Code to accelerate their own harness development — learning harness design patterns from Claude while building with it

## Key Insights

- **Error recovery as the primary quality lever.** Of all the architectural decisions Omni iterated on, adding structured error recovery had the largest single impact on Blobby's output quality. Agents that observe their own failures and retry with adjusted context significantly outperform single-pass agents.
- **Consolidate the brain — don't split knowledge.** When an outer orchestrator delegates to a sub-agent, but the outer agent doesn't know what a single sub-agent query can handle (e.g., can it handle complex joins? What are its context limits?), delegation actively harms performance. The lesson: keep reasoning about task scope and capability in a single agent when possible.
- **SQL beats proprietary query languages.** Omni's earlier architecture used a proprietary JSON-based query format. Switching to SQL brought two benefits: (1) Claude had extensive SQL training data so hallucinations dropped; (2) SQL errors are more interpretable, enabling better error recovery loops.
- **18 months of iteration compresses into patterns.** The main takeaway Omni offers is not a specific architecture but a set of hard-won patterns: error loops, brain consolidation, and leveraging the model's native training.
- **Dogfooding Claude Code to build better harnesses.** The Omni team uses Claude Code for harness development itself, treating Claude as a collaborator that can teach them how to design for Claude's interaction patterns.

## Concepts Touched

- [[concepts/agent-harness]] — production harness design, error recovery
- [[concepts/subagent-patterns]] — the "consolidate the brain" lesson challenges naive fan-out delegation
- [[concepts/context-engineering]] — SQL vs proprietary format as a context hygiene decision
- [[concepts/closing-the-loop]] — error recovery is a form of closing the loop within a task

## Notable Quotes

> "The single highest-leverage improvement we made: error recovery. Agents that catch failures and retry outperform everything else."

> "Don't split the brain. If the outer agent doesn't know what the inner agent can handle, you've made things worse, not better."

> "We switched from our proprietary query format to SQL. Claude already knows SQL. Hallucinations dropped immediately."
