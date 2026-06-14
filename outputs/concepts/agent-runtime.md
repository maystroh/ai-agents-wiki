---
title: Agent Runtime & Sandbox
tags:
  - runtime
  - infrastructure
  - sandbox
  - security
aliases:
  - Agent Runtime
  - Sandbox
  - Execution Environment
sources:
  - hidden-debt-runtime
  - hidden-debt-harness
updated: 2026-05-24
---

# Agent Runtime & Sandbox

## What is an Agent Runtime?

The **agent runtime** is the execution environment where the agent actually runs. It is distinct from the [[agent-harness]] (which governs *how* the agent operates) and the model (which provides reasoning).

Concretely, a runtime is the union of:
- **Compute substrate** — container, microVM, or full VM where code runs
- **Filesystem** the agent can read and write (often with snapshot/rollback semantics)
- **Tools** — shell, code interpreter, browser, file editor, MCP servers
- **Network boundary** — what the agent can reach, what can reach it
- **State model** — what persists across turns, episodes, and users
- **Lifecycle controller** — start, suspend, snapshot, resume, teardown

## Why Sandboxing is Non-Optional

Agents hallucinate code. They run `rm -rf`. They paste credentials into curl commands. They follow instructions embedded in untrusted documents. None of these are exotic edge cases.

Four reasons the sandbox must be a first-class layer:

1. **Isolation against model mistakes** — Filesystem isolation and copy-on-write snapshots turn destructive actions into recoverable ones
2. **Isolation against prompt injection** — Tool outputs are attacker-controlled the moment the agent reads a webpage, PDF, or email. The sandbox is what stands between an injected instruction and your production database. *This is the agent-systems version of the 2003 SQL injection lesson.*
3. **Multi-tenancy at training scale** — RL training spins up thousands of concurrent rollouts; each needs its own filesystem, process tree, network namespace
4. **Reproducibility** — A snapshotted sandbox can be replayed. Replay is how you debug a 6-hour trajectory without re-running it, and how you turn a production failure into a regression test

> [!danger] Containers are not a sandbox for agent code
> Linux containers share a host kernel. A kernel exploit, misconfigured capability, or sloppy seccomp profile defeats the isolation boundary. Cognition found that containerized agents share a kernel — a single compromised session can reach every other container's filesystem. VM-level isolation is the working assumption for untrusted-code workloads.

## Isolation Primitive Stack

| Primitive | Isolation | Cold start | Fit | Users |
|---|---|---|---|---|
| **Linux containers** | Shared kernel + namespaces | ~100ms | Trusted code, internal CI | Docker, Kubernetes |
| **Firecracker** | KVM microVM, dedicated kernel | ~125ms | Untrusted code at high density | AWS Lambda, E2B, Fly.io |
| **gVisor** | Userspace kernel intercepting syscalls | Container-class | Defense-in-depth | Google Cloud Run |
| **Kata Containers** | Lightweight VM per pod, OCI-compatible | Few hundred ms | Multi-tenant K8s | Confidential Containers |
| **V8 isolates** | Per-tenant JS heap, single process | Sub-ms | JavaScript-only | Cloudflare Workers |

> [!tip] Firecracker is the de facto industry primitive
> Almost all agent-sandbox startups (E2B, Fly.io, Vercel Sandbox) run on top of Firecracker. ~125ms boot, ~5MB VMM overhead, KVM-based isolation. "VM-level isolation" in vendor brochures almost always means Firecracker.

## Sandbox Vendor Landscape (2026)

| Vendor | Isolation | Cold start | Notable design choice |
|---|---|---|---|
| **E2B** | Firecracker microVM | ~150ms | Open-source SDK, popular in agent dev |
| **Modal** | gVisor | Sub-second from snapshot | GPU support |
| **Daytona** | Containers/VMs | Few seconds | Forked dev environments |
| **Browserbase/Steel/Hyperbrowser** | Containerized browsers | Seconds | Browser-only for web agents |
| **Vercel Sandbox** | Firecracker | Sub-second | Tied to Vercel deploy model |

## Training vs Production Want Different Runtimes

| Dimension | Training/Experimentation | Production/Serving |
|---|---|---|
| **Concurrency** | Thousands of parallel rollouts | One session per user |
| **Cold start** | Critical (5s × 10k rollouts = real money) | Tolerable |
| **State** | Fork, branch, replay, snapshot | Durable, per-user, auditable |
| **Network** | Often offline/recorded | Live internet, real APIs |
| **Failure** | Drop rollout, sample more | Retry, degrade, page someone |
| **Lifetime** | Seconds to minutes | Minutes to hours |

> [!warning] Don't "just deploy what we trained on"
> A training sandbox tuned for rollout concurrency will be too slow for production (startup cost amortized over 10k rollouts is invisible; paid by one user staring at a spinner, it's intolerable).

## The Async Gaps Problem

Real engineering work has gaps: agent opens a PR, waits on CI, responds to a review comment, reruns tests. Between each step there are minutes or hours where the agent's working state must persist.

A containerized agent survives these gaps only by burning compute to stay alive. If the container reschedules, the session is lost.

**Cognition's solution** (for Devin): hypervisor-level snapshotting of the full machine state (memory, process tree, filesystem). Compute shuts down while the agent is idle; resumes exactly where it left off when a CI result arrives. *Building this took longer than any other piece of infrastructure they shipped.*

## Runtime Shift — A New Form of Distributional Shift

An agent learns its runtime: tool latencies, failure modes, shell quirks, filesystem layout. Move the agent to a different runtime and behavior shifts silently. Evals don't catch this because they run in the training runtime.

Three ways through:
1. **Co-locate train and prod** on the same runtime (pick one sandbox provider; accept lock-in)
2. **Define a runtime contract** — small versioned interface (tool set, timing semantics, failure modes) implemented twice (train + prod)
3. **Train against production noise** — inject latency and tool failures during training so the policy is robust to variance (Step-DeepResearch: 5–10% tool error injection → tangible gains)

## See Also
- [[agent-harness]] — what runs inside the runtime
- [[context-engineering]] — state management across turns
- [[agent-memory]] — the runtime provides the filesystem substrate that memory architecture depends on
- [[automated-research]] — training-time runtime requirements for autoresearch
- [[evals-and-graders]] — runtime shift means training-runtime evals don't catch production-runtime behavior changes; eval design must account for runtime distribution
