---
name: saef-ops
description: Shared operational helpers for SAEF slash commands. Provides shell/Python scripts for scaffolding feature folders, validating context, organizing screenshots, and annotating images.
allowed-tools: Bash
---

# SAEF Ops Skill

This skill bundles all of the cross-command utilities that SAEF relies on:

- `.claude/skills/saef-ops/scripts/common.sh` – repo helpers (slug generation, path resolution, validation)
- `.claude/skills/saef-ops/scripts/init-feature.sh` – scaffolds `outputs/<slug>/` with templates and docs workspace
- `.claude/skills/saef-ops/scripts/check-context.sh` – stage-aware guardrail (refine/prd/spec/plan/implement/docs)
- `.claude/skills/saef-ops/scripts/check-archived.sh` – verifies repositories are not archived before use (exit 0 = archived, exit 1 = active)
- `.claude/skills/saef-ops/scripts/generate-screenshots.sh` – copies/backs up Playwright captures into `outputs/<slug>/docs/images/`
- `.claude/skills/saef-ops/scripts/annotate_screenshot.py` – Pillow-based annotation helper

## Usage

Every slash command should invoke these scripts via their fully-qualified path, e.g.:

```bash
bash .claude/skills/saef-ops/scripts/check-context.sh --stage spec --slug <slug>
python3 .claude/skills/saef-ops/scripts/annotate_screenshot.py <input>
```

The scripts expect to be run from the repository root. If a command needs its version, source `common.sh` from the same directory.

## Troubleshooting

When encountering issues during implementation, check known problems first:

- `docs/references/troubleshooting/` - Known issues and solutions from past sessions
- `docs/references/troubleshooting/local-dev-environment-setup.md` - Detailed guide for common environment setup issues (Java, Docker, AWS, npm, etc.)

Use these references to solve problems quickly rather than spending time rediscovering solutions.

## Maintenance

- Keep shell scripts POSIX-compatible where possible.
- Ensure new helpers live under `scripts/` within this skill so they ship alongside the prompts that call them.
- Document new issues in `docs/references/troubleshooting/` when encountered.
