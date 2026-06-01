---
title: "Why Engineers Struggle Building AI Agents"
author: Philipp Schmid
date: 2025-11-26
url: https://www.philschmid.de/why-engineers-struggle-building-agents
tags:
  - philschmid
  - agent-engineering
  - mindset
  - evals
---

# Why Engineers Struggle Building AI Agents

## Summary

- Software engineers struggle with agents because they try to apply deterministic engineering intuitions to a probabilistic system
- Introduces five mindset shifts required for agentic engineering
- Argues that junior engineers often ship faster because they trust the LLM; senior engineers over-engineer to code away the probability
- Introduces the Traffic Controller vs Dispatcher metaphor: traditional engineers own the roads, agent engineers dispatch a driver who might improvise

## Key Insights

- **You cannot code away the probability.** The more control flow you add, the more you defeat the purpose of using an agent. The skill is in the system prompt and tools, not the state machine.
- **Text is the new state.** Forcing `"This plan looks good, but focus on the US market"` into `{ "status": "APPROVED", "region": "US" }` destroys semantic richness that downstream agents depend on.
- **Errors are inputs, not failures.** An agent that runs for 5 minutes and costs $0.50 should not crash on step 4 of 5. Feed the error back, recover, continue.
- **LLMs are literalists.** Design APIs for agents like you're writing for a new hire who follows instructions exactly and infers nothing. `delete_item_by_uuid(uuid: str)` beats `delete_item(id)`.
- **Pass^k over binary pass/fail.** Run each prompt 3–5 times; measure how often it works. An agent succeeding 45/50 times with 4.5/5 quality can be production-ready.

## Concepts Touched

- [[agent-engineering]] — the full treatment of all five mindset shifts
- [[closing-the-loop]] — evals and verification as the replacement for unit tests

## Notable Quotes

> "Junior engineers often ship functional agents faster than senior engineers. The more senior the engineer, the less they trust the LLM's reasoning — and the more they try to 'code away' the probabilistic nature."

> "You are a Dispatcher. You give instructions to a driver who might take a shortcut, get lost, or decide to drive on the sidewalk because it 'seemed faster.'"
