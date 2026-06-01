---
title: Automated AI Research (Autoresearch)
tags:
  - autoresearch
  - ai-rnd
  - self-improvement
  - core-concept
aliases:
  - Autoresearch
  - AutoResearch
  - Automated AI R&D
sources:
  - autoresearch
  - karpathy-code-agents
  - import-ai-455
updated: 2026-05-24
---

# Automated AI Research (Autoresearch)

## What is Autoresearch?

**Autoresearch** is an agentic loop where an AI agent autonomously runs training experiments — editing code, measuring a metric, keeping improvements, discarding failures — without human involvement.

The core loop:
```
Give agent: training script + metric + boundary constraints
Agent: edits code → runs short experiment → checks metric → keep or discard → repeat
```

Design constraints that make it work:
- **Fixed time budget** (e.g., 5 min per experiment) — keeps comparisons fair
- **Single file scope** — agent edits `train.py` only; data prep and eval are locked
- **Git as memory** — each experiment is a commit; agent reads branch history to plan what to try next
- **Binary keep/discard** — no human judgment needed in the loop
- **Throughput**: ~12 experiments/hour → ~100 overnight

## Early Results

### Karpathy: 700 experiments on nanochat
- Pointed autoresearch at his already well-tuned GPT-2 training codebase ([nanochat](https://github.com/karpathy/nanochat))
- ~700 experiments over two days → ~20 real improvements
- Time-to-GPT-2 dropped from 2.02 → 1.80 hours (**11% faster**)
- Found things Karpathy had missed: QKNorm missing scaler multiplier, value embeddings without regularization, over-conservative attention window, suboptimal AdamW betas/weight decay

> [!quote] Karpathy
> "I let auto research go for like overnight and it came back with tunings that I didn't see. I've been doing this for two decades and still found something."

### Tobi Lütke: Overnight model training
- Adapted autoresearch for a query-expansion model in the [QMD](https://github.com/tobi/qmd) project
- Went to sleep; woke to a **0.8B model scoring 19% higher** than the previous **1.6B model**
- 37 experiments in 8 hours — smaller model outperformed one twice its size
- Then pointed the same loop at a reranker — beat that baseline too

## The Eval is the Bottleneck

> [!warning] If you can't evaluate it, you can't auto-research it
> "When experiments run 100x faster than a human can manage, your eval becomes the bottleneck. Static benchmarks get saturated. Build your eval pipeline so it can evolve." — Philipp Schmid

Requirements for the eval:
- **Held-out completely** — agent never touches the eval set during optimization
- **Reflects production** — what the model will actually do in the real world, not benchmark proxies
- **Evolvable** — refresh from real production data and harder edge cases as the loop saturates static benchmarks

Good fits: search ranking, product categorization, clinical NER, fraud scoring, contract extraction, intent classification. Small models work especially well — training runs finish in minutes, improvements transfer when you scale up.

## Autoresearch vs Prompt Optimization

| | Autoresearch | GEPA / Prompt Optimization |
|---|---|---|
| **What it changes** | Model weights (training code, architecture, hyperparameters) | Prompts (frozen models and APIs) |
| **Requires** | Training infra + data | Just an API |
| **Result** | A better model | Better prompts for the same model |
| **Works when** | You have training data + compute | Prompt-level changes are enough |

Both layers can compound when applied together.

## The Bigger Vision: Automating AI R&D

### Jack Clark's Assessment (Import AI 455, May 2026)

> [!info] 60%+ probability of automated AI R&D by 2028
> Jack Clark (co-founder Anthropic, Import AI newsletter) analyzed public evidence and concluded there's a ~60% chance a frontier model can autonomously train its successor by end of 2028.

Evidence:
- **SWE-Bench**: Claude 2 scored ~2% (2023); Claude Mythos Preview scores 93.9% (2026)
- **METR time horizons**: AI task independence went from 30 sec (GPT-3.5) → 4 min → 40 min → 6 hours → **12 hours** (Opus 4.6, 2026)
- **CORE-Bench** (research reproducibility): 21.5% (2024) → 95.5% (2025)
- **MLE-Bench** (Kaggle): 16.9% (2024) → 64.4% (2026)
- **LM training optimization**: Claude Opus 4 → 2.9× speedup (May 2025); Claude Mythos Preview → **52×** speedup (Apr 2026)
- **PostTrainBench**: AI systems achieve ~half the uplift of human researchers at post-training (25–28% vs human 51%)

### What AI Can (and Can't) Do in Research

AI excels at the "99% perspiration" (Edison) — running variations of experiments, cleaning data, launching runs, debugging — the schlep of AI engineering. 

What remains uncertain: the "1% inspiration" — whether AI can generate genuinely novel paradigm-shifting ideas (like transformers or mixture-of-experts).

> [!question] Is AI research more like discovering general relativity or Lego?
> Clark's tentative answer: Lego — methodical assembly rather than creative leaps. But that might be enough for AI to push its own development forward, just more slowly than if it can also generate novel insights.

### Industry Goal

OpenAI: "automated AI research intern by September 2026"  
Anthropic: publishing work on automated alignment researchers  
Multiple startups: Recursive Superintelligence ($500M raised), Mirendil — explicitly targeting automated AI R&D

### Implications

1. **Alignment must get right** — alignment techniques that work on today's systems may break under recursive self-improvement
2. **Productivity multiplier for everything AI touches** — like AI's impact on software engineering, but for AI development itself
3. **Capital-heavy, human-light economy** — AI-run corporations may eventually trade with each other, creating a "machine economy" within the larger human economy

## Distributed Autoresearch (Karpathy's Vision)

> [!example] "Auto Research at Home"
> Like folding@home or SETI@home, but for AI: an untrusted pool of workers on the internet could collaborate to improve LLMs. Cheap to verify (did the candidate commit improve the metric?) even if expensive to produce. Could potentially run circles around frontier labs using the Earth's distributed compute.

Key properties that make it work:
- Very expensive to find a good solution (search through commit space)
- Very cheap to verify (just train briefly and measure metric)
- Same property as folding@home, blockchain proof-of-work

## See Also
- [[agent-harness]] — the infrastructure that runs autoresearch loops
- [[agent-runtime]] — sandbox requirements for running training experiments
- [[inner-outer-loop]] — autoresearch as the ultimate outer loop (AI improving AI)
- [[agent-engineering]] — evaluations as a prerequisite for automation
