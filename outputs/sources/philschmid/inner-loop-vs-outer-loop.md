---
title: "Inner Loop vs Outer Loop"
author: Philipp Schmid
date: 2026-02-20
url: https://www.philschmid.de/inner-loop-vs-outer-loop
tags:
  - philschmid
  - reliability
  - learning
  - memory
---

# Inner Loop vs Outer Loop

## Summary

- Distinguishes two timescales of agent improvement: Inner Loop (verify within a task) and Outer Loop (carry lessons across sessions)
- Inner loop = the hardcoded while-loop at the heart of every agent; the repeated tool-call cycle within a single task
- Outer loop = the meta-level cycle that makes the agent better at future tasks based on past performance
- Presents mechanisms for each: inner (compaction, self-critique, re-planning) and outer (CLAUDE.md updates, skill creation, eval mining)
- Describes weak vs strong inner-loop agents and why the distinction matters for production reliability

## Key Insights

- **The inner loop is where task completion lives; the outer loop is where capability grows.** Most teams optimize inner loop first — outer loop is the frontier.
- **Weak inner loop agent:** asks user if stuck, gives up on tool error, doesn't re-read before saying done.
- **Strong inner loop agent:** self-corrects on error, re-reads to verify, backtracks when stuck, escalates only when genuinely blocked.
- **Spotify's outer loop:** mine transcripts of failures → update skills and CLAUDE.md → next session starts better. The outer loop closes the quality gap over time.
- **OpenClaw-style heartbeats:** proactive agents that check tasks without being prompted and carry learnings across sessions via sophisticated memory.

## Concepts Touched

- [[inner-outer-loop]] — full concept page
- [[closing-the-loop]] — inner loop mechanics
- [[agent-skills]] — outer loop mechanism (skill creation/refinement)
- [[agent-harness]] — outer harness

## Notable Quotes

> "The inner loop is what makes an agent useful today. The outer loop is what makes it more useful tomorrow."
