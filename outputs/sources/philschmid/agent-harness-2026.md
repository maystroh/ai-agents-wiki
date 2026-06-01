---
title: "The Agent Harness (2026)"
author: Philipp Schmid
date: 2026-01-05
url: https://www.philschmid.de/agent-harness-2026
tags:
  - philschmid
  - harness
  - infrastructure
  - architecture
---

# The Agent Harness (2026)

## Summary

- Defines the agent harness as the orchestration layer between model and environment — the OS to the model's CPU
- Identifies nine components: system prompt, tool surface, rollout protocol, context manager, memory, sub-agent topology, guardrails, verifiers, observability
- Introduces the Bitter Lesson for harnesses: model improvements make elaborate harness engineering obsolete every ~90 days; build to delete
- Distinguishes first-party harnesses (post-trained against the model) from third-party harnesses (framework-agnostic)
- Describes three optimization surfaces: reliability, capability, cost

## Key Insights

- **The harness is a 90-day artifact.** What requires careful harness engineering today gets absorbed by the model in the next release. Never over-invest in harness complexity.
- **First-party harnesses usually win on their target dimension.** Claude Code beats third-party frameworks on coding tasks because Claude is post-trained against Claude Code's patterns. Letta Code beats Claude Code on memory because Letta post-trained specifically for memory.
- **Thin harness, fat skills.** Move capability into modular Skills (progressive disclosure) rather than hardcoding into the harness. Skills can be updated without a harness deploy.
- **Self-healing harness.** On tool call error, harness feeds error + context back to model for self-correction before escalating.
- **Inner harness (within turn) vs Outer harness (across sessions).** Inner: compaction, tool routing, error recovery. Outer: memory, learning, capability expansion.

## Concepts Touched

- [[agent-harness]] — the full treatment
- [[agent-skills]] — Skills as the modular extension mechanism
- [[inner-outer-loop]] — inner vs outer harness distinction
- [[context-engineering]] — context manager as harness component

## Notable Quotes

> "The harness is what stands between the model's raw capability and a production system. Get it wrong and the model's raw capability means nothing."

> "Build to delete. The best harness engineers are the ones who can throw away six months of work because the model made it unnecessary."
