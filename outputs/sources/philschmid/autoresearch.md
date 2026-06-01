---
title: "AutoResearch — Agents Running ML Experiments"
author: Philipp Schmid
date: 2026-03-10
url: https://www.philschmid.de/autoresearch
tags:
  - philschmid
  - autoresearch
  - ai-rnd
  - evals
---

# AutoResearch — Agents Running ML Experiments

## Summary

- Explains the autoresearch loop: agent edits training code → runs short experiment → checks metric → keeps or discards → repeats
- Design constraints that make it work: fixed time budget, single file scope, git as memory, binary keep/discard
- ~12 experiments/hour → ~100 overnight
- The eval is the bottleneck: if you can't measure it, you can't automate it
- Good fits: search ranking, categorization, clinical NER, fraud scoring — all domains with clear, held-out metrics

## Key Insights

- **Git as memory.** Each experiment is a commit. The agent reads branch history to plan what to try next — branching patterns from past results inform the search strategy.
- **Single-file scope prevents scope creep.** Agent edits `train.py` only; data and eval are locked. This keeps comparisons fair and prevents the agent from gaming the metric.
- **The eval must be held-out completely.** If the agent can observe the eval set during optimization, it will overfit to it.
- **Static benchmarks get saturated.** At 12 experiments/hour, an agent saturates a static benchmark faster than a human can refresh it. Build evolvable evals that pull from production data.
- **Small models benefit most.** Training runs finish in minutes, improvements compound, and the resulting models often outperform larger baselines trained without the loop.

## Concepts Touched

- [[automated-research]] — full concept page
- [[agent-engineering]] — evals as prerequisite for automation
- [[agent-runtime]] — the execution environment for training experiments

## Notable Quotes

> "When experiments run 100x faster than a human can manage, your eval becomes the bottleneck."
