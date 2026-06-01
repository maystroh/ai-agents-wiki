---
title: "Hidden Technical Debt of AI Systems: Agent Runtime"
author: Unknown
date: 2025
tags:
  - misc
  - runtime
  - sandbox
  - security
  - infrastructure
---

# Hidden Technical Debt of AI Systems: Agent Runtime

## Summary

- Argues that sandboxing is non-optional for agent systems, not a polish item
- Identifies four reasons: isolation against model mistakes, isolation against prompt injection, multi-tenancy at training scale, reproducibility/replay
- Covers the isolation primitive stack: Linux containers, Firecracker microVMs, gVisor, Kata Containers, V8 isolates
- Documents Cognition's hypervisor-level snapshotting solution for async gaps (Devin waiting on CI results)
- Identifies runtime shift as a new form of distributional shift

## Key Insights

- **Containers are not a sandbox for agent code.** Shared kernel means a single compromised container can reach every other container's filesystem. Use VM-level isolation (Firecracker) for untrusted code.
- **Firecracker is the de facto industry primitive.** ~125ms boot, ~5MB VMM overhead, KVM-based isolation. Every agent sandbox startup (E2B, Vercel, Fly.io) runs on Firecracker.
- **Training and production need different runtimes.** Training optimizes for concurrency (thousands of parallel rollouts). Production optimizes for cold start, per-user state, and durability.
- **Async gaps are the hard problem.** Agent opens PR, waits on CI — the container must stay alive or lose state. Cognition's solution: hypervisor snapshots that hibernate on idle and resume exactly.
- **Runtime shift is silent.** Moving an agent from training runtime to production runtime changes tool latencies, failure modes, and shell behavior — without any eval catching it.

## Concepts Touched

- [[agent-runtime]] — full concept page
- [[agent-harness]] — what runs inside the runtime
- [[automated-research]] — training-time runtime requirements

## Notable Quotes

> "Tool outputs are attacker-controlled the moment the agent reads a webpage, PDF, or email. The sandbox is what stands between an injected instruction and your production database."
