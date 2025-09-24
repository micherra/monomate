# 🧩 Monomate

> **Your workspace buddy for monorepos.**
> Stop memorizing paths and package manager quirks — Monomate makes large JS/TS monorepos friendlier with simple, memorable commands.

## What is it?

Monomate is a **fast, cross-platform CLI** (written in Go) that wraps common workspace operations in a consistent, developer-friendly interface.

* Works with modern package managers (Bun first; pnpm/Yarn/npm planned)
* Prioritizes **safety, clarity, and DX**
* Provides interactive tools to navigate and manage workspaces with confidence

**Core ideas:**

* 🚀 Simple commands: `add`, `remove`, `install`, `run`
* 🔍 Target workspaces by name with fuzzy search or interactive select
* 🩺 Helpful `info` and `doctor` commands to explain + fix issues
* 🎯 Configurable aliases so teams can share handy shortcuts

## Why build it?

Monorepos are powerful but full of paper cuts:

* Different syntaxes across package managers
* Deep, hard-to-remember paths
* Version drift and inconsistent commands

Monomate removes this friction so developers can move faster — and trust their tooling.

## Status

⚠️ **Work in progress.**

## Planned features (at a glance)

* `add/remove/install/run` across workspaces by name
* Interactive selection with fuzzy search
* `info` (path, scripts, deps) and `doctor` (mismatches, missing configs)
* Configurable aliases with placeholders
* Support for Bun, pnpm, Yarn, and npm

## Quick start (temporary, from source)

Build a local binary:

```bash
make build
./bin/monomate --help
```

Dogfood from anywhere (installs to your Go bin dir):

```bash
make install
monomate --version
```

Remove the installed binary:

```bash
make uninstall
```

## License

Licensed under the [Apache License 2.0](./LICENSE).

**In plain terms:**

* ✅ Free to use, share, and modify
* ✅ Contributions welcome
* ✅ Explicit patent grant (enterprise-friendly)
* ❌ No warranty — use at your own risk
