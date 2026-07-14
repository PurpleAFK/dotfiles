#!/usr/bin/env bash
set -euo pipefail
NAME="${1:?usage: scaffold-project.sh <name>}"
DIR="$HOME/code/$NAME"
[ -d "$DIR" ] && { echo "Exists: $DIR"; exit 1; }
mkdir -p "$DIR"/{src,tests,docs,scripts,notebooks,data}
cd "$DIR"
cat > pyproject.toml <<PYPROJ
[project]
name = "$NAME"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = ["numpy", "torch"]
[project.optional-dependencies]
dev = ["pytest>=8", "hypothesis>=6", "ruff>=0.6", "pre-commit>=3"]
[tool.ruff]
line-length = 100
target-version = "py311"
[tool.ruff.lint]
select = ["E", "F", "I", "N", "UP", "B", "SIM"]
PYPROJ
cat > .gitignore <<GIT
__pycache__/
*.py[cod]
.venv/
.pytest_cache/
.ruff_cache/
data/
*.pt
*.onnx
*.ckpt
wandb/
.env
.DS_Store
GIT
cat > .pre-commit-config.yaml <<PC
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.9
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ["--maxkb=1024"]
PC
mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<CI
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python: ["3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v3
      - uses: actions/setup-python@v5
        with:
          python-version: \${{ matrix.python }}
      - run: uv sync --extra dev
      - run: uv run ruff check
      - run: uv run pytest -q
CI
cat > README.md <<RM
# $NAME
## Setup
\`\`\`
uv sync --extra dev
pre-commit install
\`\`\`
## Test
\`\`\`
uv run pytest
\`\`\`
RM
echo "MIT License" > LICENSE
git init -q
git add -A
git commit -q -m "chore: initial scaffold"
echo "Scaffolded $DIR"
