---
title: "Code Agents, AutoResearch, and the Loopy Era of AI"
author: Andrej Karpathy
date: 2026-03-20
tags:
  - karpathy
  - autoresearch
  - code-agents
  - ai-rnd
---

# Code Agents, AutoResearch, and the Loopy Era of AI

## Summary

- Karpathy's March 2026 talk covering the trajectory from coding assistants to autonomous research agents
- Introduces autoresearch: agent edits training code → runs experiment → checks metric → keeps or discards → repeats using git as memory
- Reports on 700 experiments run against his nanochat codebase over two days: 11% training speedup, finding improvements Karpathy had missed after two decades of work
- Proposes distributed autoresearch ("Auto Research at Home"): folding@home model for AI improvement using untrusted distributed compute

## Key Insights

- **Git as experiment memory.** Each experiment is a commit. The agent reads branch history to know what's been tried, what worked, what didn't — avoiding retreading failed paths.
- **700 experiments, 20 improvements.** The agent found a missing QKNorm scaler multiplier, value embeddings without regularization, an over-conservative attention window, and suboptimal AdamW hyperparameters — all in Karpathy's well-tuned codebase.
- **Overnight beats two decades.** The humility point: AI-driven experimentation found improvements a domain expert had missed, simply through scale of search.
- **Distributed autoresearch is asymmetric.** Very expensive to find a good commit; very cheap to verify (brief train + metric). Same property as folding@home. The Earth's distributed compute could run circles around frontier labs.
- **The "loopy era."** Karpathy's framing: we've entered an era where the most important loops are not inside a single model forward pass, but between models running experiments on themselves.

## Concepts Touched

- [[automated-research]] — full concept page
- [[agent-runtime]] — execution environment for experiments
- [[inner-outer-loop]] — autoresearch as the ultimate outer loop (AI improving AI)

## Notable Quotes

> "I let auto research go for like overnight and it came back with tunings that I didn't see. I've been doing this for two decades and still found something."

> "Very expensive to find a good solution. Very cheap to verify. That's the same property as folding@home, blockchain proof-of-work. The Earth's distributed compute could run circles around frontier labs."
