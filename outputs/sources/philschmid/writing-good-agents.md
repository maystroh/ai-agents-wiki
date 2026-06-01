---
title: "Writing a Good AGENTS.md"
author: Philipp Schmid
date: 2026-02-24
url: https://www.philschmid.de/writing-good-agents
tags:
  - philschmid
  - agent-engineering
  - agents-md
  - configuration
---

# Writing a Good AGENTS.md

## Summary

- Evidence-backed guide to writing effective AGENTS.md / CLAUDE.md files, drawing on ETH Zurich research (2025) and HumanLayer practical experience
- Finding: auto-generated AGENTS.md files reduce task success by ~3% while increasing cost 20%+
- Finding: human-written files improve performance only ~4% but still increase cost ~19%
- Finding: codebase overviews don't help agents navigate; agents find files equally fast without them
- Prescribes: what to include (stack, purpose, build/test commands), what to exclude (style guides, auto-generated content, task-specific instructions)

## Key Insights

- **Less is more.** Every line goes into every session. Unnecessary requirements make tasks harder — agents follow instructions even when following them is counterproductive.
- **Tools mentioned get used 160× more.** If a non-obvious tool (`uv`, `bun`) isn't in AGENTS.md, it won't be used. Mention it once, keep everything else out.
- **Use progressive disclosure.** Keep AGENTS.md under 300 lines (HumanLayer: under 60). Point to `agent_docs/running_tests.md` rather than embedding the content.
- **Stronger models don't generate better context files.** GPT-5.2-generated AGENTS.md improved one benchmark by 2% but degraded another by 3% — no reliable uplift.
- **Write it yourself, deliberately.** Treat AGENTS.md like infrastructure. A bad line cascades into bad plans, bad code, and bad results across every session.

## Concepts Touched

- [[agent-harness]] — AGENTS.md as the behavioral contract / system prompt layer
- [[agent-skills]] — progressive disclosure as alternative to embedding content in AGENTS.md
- [[agent-engineering]] — the mindset of treating configuration as infrastructure

## Notable Quotes

> "A bad line in AGENTS.md cascades into bad plans, bad code, and bad results across every session. Treat it like infrastructure, not a scratchpad."

> "Frontier models can reliably follow ~150–200 instructions; the agent harness already uses ~50 of those."
