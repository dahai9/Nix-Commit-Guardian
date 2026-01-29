# Nix Commit Guardian

Nix Commit Guardian is an AI-powered commit message generator specifically designed for NixOS configuration repositories. It analyzes your staged changes and suggests meaningful, structured git commit messages using LLMs.

## 🚀 Features

- **Smart Analysis**: Automatically parses `git diff --staged`.
- **AI-Powered Suggestions**: Uses OpenAI (or compatible APIs) to generate context-aware summaries.
- **Structured Logic**: Ensures commit messages follow a clear pattern (Type, Summary, Reasoning).
- **Nix Native**: Built with Nix Flake support for a guaranteed reproducible development environment.

## 📋 Prerequisites

- **Nix** with Flakes enabled.
- An **OpenAI API Key** (or compatible provider).

## 🛠️ Getting Started

### 1. Enter the Environment
This project uses a Nix development shell to provide all necessary tools (`node`, `pnpm`, `typescript`).

```bash
nix develop
```

### 2. Configuration
Create a `.env` file in the root directory:

```env
OPENAI_API_KEY=your_api_key_here
OPENAI_BASE_URL=https://api.openai.com/v1
OPENAI_MODEL=gpt-4o
```

*Note: Default base URL is `http://localhost:8000/v1` and default model is `cerebras/gpt-oss-120b` if not specified.*

### 3. Usage
Stage your changes first, then run the tool:

```bash
git add .
pnpm dev
```

## 🏗️ Building and Packaging

### Standard Build (TypeScript to JS)
```bash
pnpm build
```

### Build with Nix
To build the project as a Nix package:
```bash
nix build
./result/bin/nix-commit-guardian
```

### Create Standalone Binary (via pkg)
```bash
pnpm pkg
```
This generates a standalone `nix-commit-guardian` binary in the root directory.

## 📄 License
ISC
