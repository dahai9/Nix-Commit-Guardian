# Nix Commit Guardian

Nix Commit Guardian is an AI-powered commit message generator specifically designed for NixOS configuration repositories. It automatically analyzes Git staged changes and leverages Large Language Models (LLMs) to generate structured, descriptive, and compliant commit suggestions.

### Key Features

- **Smart Diff Analysis**: Automatically extracts and analyzes Git staged changes.
- **AI-Powered**: Integrates with OpenAI API to generate commit types, summaries, and reasoning based on actual changes.
- **Structured Output**: Uses Zod for strict schema validation to ensure consistent and reliable commit messages.
- **Nix Ecosystem Integration**: Native Nix Flake support for a consistent development and build environment.

---

## 🔧 NixOS Flake Development Workflow

### ⚠️ Critical Rule: Initialize Flake Shell First

**Before running ANY pnpm commands**, you MUST initialize the Nix flake development shell.

```bash
# Step 1: Enter the flake development environment
nix develop

# Step 2: Only then can you run pnpm and other tools
pnpm install
pnpm build
pnpm dev
pnpm pkg
```

### Why?

- All development tools (pnpm, nodejs, typescript, zsh) are defined in `flake.nix` under `devShells`
- Without `nix develop`, these tools are not available in the environment
- `nix develop` sets up the proper shell context with all dependencies

### Error Reference

If you see: `command not found: pnpm` or similar errors, it means:
- ❌ You tried to run pnpm without entering the flake shell
- ✅ Run `nix develop` first, then retry

### Complete Command Sequence

```bash
nix develop              # Enter flake development environment
pnpm install           # Install dependencies
pnpm build             # Compile TypeScript
pnpm dev               # Run in development mode
pnpm pkg               # Package as binary
```

### Reminders

- Always start with `nix develop` when working in this project
- This is a one-time setup per terminal session
- After exiting the shell (Ctrl+D or `exit`), you'll need to run `nix develop` again in a new terminal

---

## Project Information

- **Name**: nix-commit-guardian
- **Type**: TypeScript CLI + NixOS
- **Package Manager**: pnpm
- **Shell**: zsh (auto-launched by flake.nix)
- **Build**: tsc (TypeScript compiler)
