---
title: "From Vibe Coding to Agentic Engineering"
author: Andrej Karpathy
date: 2026-04-29
tags:
  - karpathy
  - agent-engineering
  - agentic-engineering
  - mindset
---

# From Vibe Coding to Agentic Engineering

## Summary

- Karpathy's April 2026 talk distinguishing "vibe coding" (floor-raising, anyone can build) from "agentic engineering" (preserving quality while going faster)
- Coins "agentic engineering" as the discipline of coordinating stochastic agents without sacrificing correctness or security
- Introduces the "jaggedness" observation: models simultaneously feel like a PhD systems programmer and a 10-year-old — fast-improving on verifiable domains, slow on softer ones
- Claims people who are excellent at agentic engineering peak well beyond 10× productivity

## Key Insights

- **Vibe coding ≠ agentic engineering.** Vibe coding raises the floor — anyone can build anything by vibing with an LLM. Agentic engineering is the discipline of doing it *right*: coordinating agents without sacrificing quality.
- **"People who are very good at this peak a lot more than 10x."** The leverage is real, but it comes from the discipline, not just from using the tools.
- **The jaggedness problem persists.** Models improve rapidly on verifiable tasks (code, math, formal proofs). Softer domains (nuance, aesthetic judgment, clarifying questions) improve more slowly. This jaggedness is the reason agentic engineering exists — you can't just trust the model blindly.
- **Domains outside the RL reward signal are the danger zones.** Models are trained heavily on verifiable rewards. Anything that can't be scored automatically is where the 10-year-old shows up.
- **The taste problem remains human.** Specification (what you want, not how), aesthetics (elegant vs merely correct), and oversight of weird edge cases remain hard to delegate.

## Concepts Touched

- [[agent-engineering]] — the five mindset shifts and the taste problem
- [[automated-research]] — agentic engineering applied to AI R&D
- [[closing-the-loop]] — verification as the mechanism that makes agentic engineering reliable

## Notable Quotes

> "Agentic engineering is how do you coordinate agents to go faster without sacrificing your quality bar."

> "I simultaneously feel like I'm talking to an extremely brilliant PhD student who's been a systems programmer their entire life, and a 10-year-old. The jaggedness is really strange."
