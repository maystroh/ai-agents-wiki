---
title: "Import AI 455 — Automating AI Research"
author: Jack Clark
date: 2026-05-04
url: https://importai.substack.com/p/import-ai-455
tags:
  - import-ai
  - autoresearch
  - ai-rnd
  - forecasting
---

# Import AI 455 — Automating AI Research

## Summary

- Jack Clark (co-founder Anthropic, Import AI newsletter) analyzes public evidence and concludes ~60% probability that a frontier model can autonomously train its successor by end of 2028
- Surveys benchmark trajectories: SWE-Bench 2%→93.9%, METR task horizons 30sec→12hr, CORE-Bench 21.5%→95.5%, MLE-Bench 16.9%→64.4%
- LM training optimization: Claude Opus 4 achieved 2.9× speedup (May 2025); Claude Mythos Preview achieved 52× speedup (April 2026)
- PostTrainBench: AI achieves ~half the uplift of human researchers at post-training (25–28% vs human 51%)
- Industry goal: OpenAI targets "automated AI research intern by September 2026"

## Key Insights

- **The trajectory is the argument.** Clark doesn't argue from first principles — he plots benchmark curves and extrapolates. The case for 60% by 2028 rests on the consistency of the improvement rate, not on any single breakthrough.
- **52× LM training optimization is the headline number.** Claude Mythos Preview finding a 52× speedup in training optimization (April 2026) is the most striking data point — far beyond incremental improvement.
- **AI does the "99% perspiration" well.** Running experiment variations, cleaning data, launching runs, debugging — the schlep of AI engineering. The "1% inspiration" (novel paradigm-shifting ideas like transformers) remains uncertain.
- **"Is AI research more like discovering general relativity or Lego?"** Clark's tentative answer: Lego. Methodical assembly rather than creative leaps. That may be enough for recursive self-improvement, just slower.
- **Alignment must get ahead of this.** Techniques that work on today's systems may break under recursive self-improvement. The urgency is structural, not just a capability concern.
- **Machine economy implication.** AI-run corporations trading with each other could create a "machine economy" embedded within the human economy — not replacement, but a new economic layer.

## Concepts Touched

- [[automated-research]] — the full analysis lives here
- [[agent-engineering]] — evals as a prerequisite for automation
- [[agent-runtime]] — infrastructure requirements for large-scale autoresearch

## Notable Quotes

> "60%+ probability of automated AI R&D by 2028."

> "AI achieves roughly half the research uplift of human researchers at post-training: 25–28% vs human researchers' 51%."

> "Is AI research more like discovering general relativity or Lego? My tentative answer: Lego — methodical assembly rather than creative leaps."
