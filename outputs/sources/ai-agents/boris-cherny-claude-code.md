---
title: "Claude Code Head Boris Cherny: Insane Growth, Tokenmaxxing, AI Agents' Next Frontier"
author: Alex Kantrowitz (interview with Boris Cherny)
date: 2026-05-23
url: https://www.youtube.com/watch?v=Z6IT4gjrcPE
tags:
  - claude-code
  - tokenmaxxing
  - auto-mode
  - agent-engineering
  - anthropic
  - ai-agents
sources:
  - "AI Agents/Alex Kantrowitz/2026-05-23"
updated: 2026-05-24
---

# Claude Code Head Boris Cherny: Insane Growth, Tokenmaxxing, AI Agents' Next Frontier

## Summary

- Boris Cherny (Claude Code lead at Anthropic) describes exponential growth: 250%+ increase in code output across Anthropic's engineering org since Claude Code adoption
- Tokenmaxxing is a small fraction of real usage — the majority of Claude Code tokens come from genuine deep work, not metric gaming
- Auto Mode: a second Claude instance acts as a trust judge, evaluating tool call safety instead of routing every action through a human approval prompt
- The near-future: hundreds to thousands of parallel Claude agents running autonomously for a single user
- Meta-note: Claude Code is 100% written by Claude Code itself — Anthropic uses it as a dogfood environment

## Key Insights

- **The 250% signal is real.** Anthropic's own engineers produce 250%+ more code than before Claude Code. Cherny treats this as the ground-truth signal above all other metrics.
- **Tokenmaxxing is a rounding error.** Some users game token counts by prompting verbosely, but this is a small fraction of total usage. The bulk of tokens represent genuine deep reasoning and tool execution. Cherny doesn't find it concerning.
- **Auto Mode changes the trust model.** Instead of pausing to ask the user "is this tool call ok?", Auto Mode routes the question to a second Claude instance that evaluates safety in context. Human is removed from the inner loop; the second Claude is the safety layer. This enables much faster autonomous execution.
- **Parallel agents as the next frontier.** Cherny's framing of the near future: a single user orchestrates hundreds or thousands of Claude agents running in parallel on different tasks. The harness for this — routing, memory, result synthesis — is the unsolved problem.
- **Claude Code written by Claude Code.** The entire Claude Code codebase is maintained and extended by Claude Code itself. This is both a technical claim and a philosophical stance: Anthropic's highest-confidence dogfood.
- **First-party post-training advantage.** Claude is post-trained specifically on Claude Code interaction patterns, which is why Claude Code outperforms generic agent frameworks on its target tasks.

## Concepts Touched

- [[concepts/agent-harness]] — Auto Mode is a harness-level trust architecture
- [[concepts/agent-skills]] — Boris Cherny also discussed skill design in other sources
- [[concepts/agent-engineering]] — exponential code output as the metric for agentic impact
- [[concepts/subagent-patterns]] — parallel agent fleets as next-frontier pattern
- [[entities/people]] — Boris Cherny profile
- [[entities/tools-products]] — Claude Code product entry

## Notable Quotes

> "250% more code output across our engineering org — that's the number I care about, not token counts."

> "Auto Mode puts a second Claude in the loop instead of a human. It evaluates whether the tool call is safe. The user doesn't have to approve every action."

> "Claude Code is 100% written by Claude Code."

> "The future is hundreds, maybe thousands of parallel agents running for a single user."
