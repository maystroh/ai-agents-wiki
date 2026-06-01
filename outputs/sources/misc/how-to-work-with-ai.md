---
title: "How to Work and Compound with AI"
author: Eugene Yan
date: 2025
tags:
  - misc
  - agent-engineering
  - workflow
  - productivity
---

# How to Work and Compound with AI

## Summary

- Eugene Yan's practical workflow for high-leverage collaboration with AI agents
- Five components: Context as infrastructure, Taste as configuration, Verification for autonomy, Delegation, Closing the loop
- Advocates running 3–6 sessions in parallel using git worktrees for different approaches to the same problem
- Pair programmer pattern: two tmux panes, shared instruction file, secondary agent monitors primary for drift

## Key Insights

- **Context as infrastructure.** Maintain an organized workspace the model can navigate with `grep`/`glob`. Annotated INDEX.md per project. This is not documentation — it's the agent's memory.
- **Taste as configuration.** CLAUDE.md as behavioral contract: "Be direct. Push back when you disagree." Encode your aesthetic and judgment into config so agents reflect it.
- **Post-edit hooks as cheapest verification.** `ruff format`, `ruff check` after every file write. Escalate to tests, evals, and LLM reviews only when hooks don't catch it.
- **Parallel sessions via git worktrees.** Run 3–6 independent agents on the same task. Compare outputs. The best solution often comes from a session you didn't expect.
- **Mine transcripts for config updates.** When an agent makes a recurring mistake, the fix goes into CLAUDE.md or a Skill — not into the next conversation's context.

## Concepts Touched

- [[agent-engineering]] — the five mindset shifts
- [[closing-the-loop]] — pair programmer pattern and transcript mining
- [[inner-outer-loop]] — outer loop via transcript mining → config updates
- [[agent-skills]] — skills as encoded taste

## Notable Quotes

> "Taste as configuration. Your CLAUDE.md is a behavioral contract with the agent — encode your aesthetic and judgment into it, so agents reflect your values without you repeating yourself."
