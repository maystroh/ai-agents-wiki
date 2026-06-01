---
title: "Closing the Loop — Agent Self-Verification"
author: Philipp Schmid
date: 2026-02-17
url: https://www.philschmid.de/closing-the-loop
tags:
  - philschmid
  - reliability
  - verification
  - self-awareness
---

# Closing the Loop — Agent Self-Verification

## Summary

- Defines loop-closing as an agent verifying its own work against external signals (compiler, test runner, filesystem, another LLM) before returning to the user
- Distinguishes scaffolded verification (built into the harness) from spontaneous verification (agent-initiated)
- Presents Spotify's production approach: independent verifiers exposed as a single MCP "verify" tool + LLM judge for scope-drift detection
- Introduces the pair programmer pattern: a secondary agent with fresh context monitors the primary for execution and direction drift
- Cites Anthropic's introspection research: Claude can distinguish injected outputs from its own generated ones

## Key Insights

- **"The good ones feel like working with a colleague."** They plan, check, catch their own mistakes, and only then say they're done.
- **Self-awareness is operational, not philosophical.** It means: knowing your context window size, knowing which tool to use, and being calibrated about your own uncertainty.
- **DeepMind's spontaneous self-critique: 50% → 89% planning success.** A single LLM checking its own plan step-by-step against task rules (without any external signal) boosted success dramatically.
- **Scaffolded is today's standard; spontaneous is the trajectory.** Most production loop-closing is built *around* the agent, not *by* the agent.

## Concepts Touched

- [[closing-the-loop]] — full concept page
- [[inner-outer-loop]] — inner loop as the verification cycle
- [[agent-harness]] — scaffolded verification as a harness responsibility

## Notable Quotes

> "The good ones feel like working with a colleague. They plan, check, and try to catch their own mistakes and only then tell you it's done." — Philipp Schmid
