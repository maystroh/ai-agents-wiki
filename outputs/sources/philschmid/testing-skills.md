---
title: "Testing Agent Skills"
author: Philipp Schmid
date: 2026-03-04
url: https://www.philschmid.de/testing-skills
tags:
  - philschmid
  - skills
  - evals
  - testing
---

# Testing Agent Skills

## Summary

- Provides a framework for evaluating whether an Agent Skill works as intended
- Three-level test structure: trigger test (does the index description load the skill?), execution test (does the body produce correct behavior?), integration test (does it compose with other tools?)
- Distinguishes common failure modes: over-triggering, under-triggering, ambiguous description overlap between skills
- Introduces the "taste" check: a human audit of whether the skill output matches intent, not just correctness

## Key Insights

- **Test the index description, not just the body.** The description is what controls when the skill loads. A skill with perfect content but a poor description never fires — or fires on the wrong prompts.
- **Over-triggering is often worse than under-triggering.** A skill that loads when it shouldn't inflates context on every task — a permanent tax.
- **Ambiguous skill overlap causes context confusion.** Two skills with similar descriptions create a selection race that the model may resolve inconsistently. Rename one or merge them.
- **Retiring skills matters.** An unused skill that stays in the index still costs tokens on every session. Regular pruning is part of skill maintenance.

## Concepts Touched

- [[agent-skills]] — the skill architecture being tested
- [[agent-engineering]] — evals over unit tests
- [[inner-outer-loop]] — skill testing as part of the outer loop

## Notable Quotes

> "A skill with perfect content but a poor description never fires — or fires on the wrong prompts. Test the index description first."
