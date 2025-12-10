# Soracom AI Engineering Framework (SAEF)

> [!WARNING]
> **Experimental**: This framework is under active development. Expect rough edges and incomplete features. If you encounter issues or want to provide feedback, try `/saef:debug:review-session` to generate a summary of challenges and suggested improvements.

SAEF is an AI-assisted feature development framework that guides features from ideation through release using structured slash commands. Conceptually similar to [GitHub Spec Kit](https://github.com/github/spec-kit), tailored to Soracom's repositories, standards, and workflows. Much of the context comes from the engineering team's documentation on Notion and repository documentation. Each command produces artifacts stored in `outputs/<YYYY-MM-DD>-<slug>/`.

---

## Table of Contents

- [Philosophy](#philosophy)
- [What SAEF Is (and Isn't)](#what-saef-is-and-isnt)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Lifecycle Commands](#lifecycle-commands)
- [Debug Commands](#debug-commands)
- [Skills Reference](#skills-reference)
- [Hooks](#hooks)
- [Test Scenarios](#test-scenarios)
- [Future Directions](#future-directions)
- [Contributing](#contributing)

---

## Philosophy

How SAEF thinks about AI-assisted feature development.

SAEF exists to let anyone contribute features, not just engineers.

Sales, support, operations, and other teams often identify small improvements that would unblock their work or make daily tasks more efficient. But turning those ideas into shipped features typically requires navigating unfamiliar processes, writing technical specifications, and coordinating across multiple repositories. SAEF removes those barriers.

**Core principles**:

1. **Accessible entry point**: Anyone can start a feature with `/saef:1-refine`. No engineering background needed. Later stages (PRD, spec, implementation) are handled by engineers who can answer technical questions.

2. **Seamless end-to-end**: From initial idea to released feature, each stage flows into the next. No context is lost between steps.

3. **Ask, don't assume**: Commands ask clarifying questions rather than inferring or fabricating information. If something is unclear, SAEF asks.

4. **Human decisions**: AI generates drafts and suggestions. Humans review, approve, and decide. Nothing auto-publishes or auto-deploys.

5. **Inspectable artifacts**: Each stage produces files you can read, edit, and share. If something goes wrong, you can fix it directly.

6. **Balanced autonomy**: SAEF gives the AI agent autonomy to discover information (searching repos, analyzing patterns) while providing clear guidance through skills and templates. The agent has the right signposting to be effective without being micro-managed.

---

## What SAEF Is (and Isn't)

Setting realistic expectations.

**SAEF helps with**:
- Taking a feature idea from "I wish we could..." to a clear business statement
- Generating PRDs, API specs, and test plans
- Breaking work into tasks
- Writing code and tests
- Producing documentation and changelog drafts

**SAEF does not**:
- Prioritize features or decide what to build next
- Automatically push code, create PRs, or deploy
- Replace human review and decision-making

---

## Directory Structure

How files are organized in this repository.

```text
saef/
├── .claude/
│   ├── commands/saef/           # Slash command definitions
│   │   ├── 1-refine.md          # Feature intake
│   │   ├── 2-prd.md             # PRD generation
│   │   ├── 3-spec.md            # API spec & test plan
│   │   ├── 4-plan.md            # Task breakdown
│   │   ├── 5-implement.md       # Implementation
│   │   ├── 6-docs.md            # Documentation (🧪 experimental)
│   │   ├── 7-release.md         # Changelog (🧪 experimental)
│   │   └── debug/
│   │       └── review-session.md # Session analysis
│   ├── skills/                  # Specialized knowledge modules
│   │   ├── saef-ops/
│   │   ├── soracom-backend-guidelines/
│   │   ├── soracom-changelog-writer/
│   │   ├── soracom-diagram-generator/
│   │   ├── soracom-documentation-writer/
│   │   ├── soracom-frontend-guidelines/
│   │   ├── soracom-github-lifecycle/
│   │   ├── soracom-release-lifecycle/
│   │   ├── soracom-repository-catalog/
│   │   ├── soracom-screenshot-generator/
│   │   ├── soracom-shortcut-lifecycle/
│   │   └── soracom-testing-guidelines/
│   ├── hooks/                   # Automation hooks
│   │   ├── markdown_formatter.py
│   │   └── check_context_guardrail.sh
│   └── settings.json            # Hooks and permissions config
├── .github/
│   ├── CODEOWNERS               # Code ownership
│   └── pull_request_template.md # PR template
├── docs/
│   ├── examples/                # Example artifacts
│   ├── templates/               # Reference templates
│   ├── references/              # Standards and SOPs
│   │   └── troubleshooting/     # Known issues and solutions
│   └── repositories.yaml        # Repository catalog
├── outputs/                     # Feature artifacts
│   ├── session_reviews/         # Session analyses
│   └── <YYYY-MM-DD>-<slug>/     # One folder per feature
│       ├── .saef-metadata
│       ├── 1-business-statement.md
│       ├── 2-prd.md
│       ├── 2-pattern-analysis.md
│       ├── 3-api-spec.yaml
│       ├── 3-test-plan.md
│       ├── 3-repo-analysis.md
│       ├── 4-tasks.md
│       ├── 4-stories/
│       ├── 5-quality-checklist.md
│       ├── 5-pr-descriptions/
│       ├── 6-docs/
│       └── 7-release/
├── repos/                       # Product repositories (cloned automatically)
├── AGENTS.md                    # Agent behavior guidelines
└── CLAUDE.md                    # AI instructions for this repository
```

Artifact files are prefixed with the command number (1-7) that creates them, making it clear which stage produced each file.

---

## Getting Started

How to set up and run your first feature.

### Prerequisites

> [!NOTE]
> Required tools and access for running SAEF workflows.

- **Claude Code** (CLI or IDE extension)
- **Python 3**, **jq** - For helper scripts
- **Git** and **GitHub CLI** (`gh`) - For repository operations
- **Access to Soracom repositories** - GitHub SSH keys configured
- **AWS credentials** - Required for some repositories (e.g., billing, session-manager)

> [!TIP]
> Keep product repositories up to date with their main/master branches before running pattern analysis in `/saef:2-prd`.

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/soracom/saef
   cd saef
   ```

2. Open your IDE in this directory and start Claude Code:
   - **VS Code**: Open the Command Palette and select "Claude Code: Open"
   - **Terminal**: Run `claude` in this directory

3. The `.claude/settings.json` file configures hooks and permissions automatically.

   > [!TIP]
   > Personal settings can be stored in `.claude/settings.local.json` (not tracked in git).

4. Product repositories will be cloned automatically by the system into the `./repos/` folder as needed during the workflow.

   > [!NOTE]
   > Some repositories may require AWS credentials to be configured.

### Quick Start

```bash
# Start with a feature idea
/saef:1-refine "Add PUK code display to subscriber details page"

# Generate PRD
/saef:2-prd

# Continue through the lifecycle...
/saef:3-spec
/saef:4-plan
/saef:5-implement
/saef:6-docs       # 🧪 Experimental
/saef:7-release    # 🧪 Experimental

# Optional: Provide feedback on your session
/saef:debug:review-session
```

---

## Lifecycle Commands

The seven stages of feature development.

| Command | Purpose | Input | Output |
|---------|---------|-------|--------|
| `/saef:1-refine` | Capture feature idea as business statement | Feature idea | `1-business-statement.md` |
| `/saef:2-prd` | Generate PRD, discover patterns from recent PRs | `1-business-statement.md` | `2-prd.md`, `2-pattern-analysis.md` |
| `/saef:3-spec` | Define API contracts and test requirements | `2-prd.md` | `3-api-spec.yaml`, `3-test-plan.md`, `3-repo-analysis.md` |
| `/saef:4-plan` | Break down into actionable tasks | `2-prd.md`, `3-*.md` | `4-tasks.md`, `4-stories/` |
| `/saef:5-implement` | Write code and tests, commit locally | `4-tasks.md` | Code in `repos/`, `5-quality-checklist.md`, `5-pr-descriptions/` |
| `/saef:6-docs` 🧪 | Generate user documentation | `2-prd.md`, `5-*.md` | `6-docs/docs-ja.md`, `6-docs/docs-en.md` |
| `/saef:7-release` 🧪 | Generate changelog drafts | `2-prd.md`, `6-docs/` | `7-release/changelog-*.md` |

### Common Arguments

- **`--slug <YYYY-MM-DD-slug>`** - Target a specific feature (required when multiple features exist)
- **`--lang en|ja|ja-en`** - Output language (default: `en`)
  - Applies to: `/saef:1-refine`, `/saef:2-prd`, `/saef:6-docs`, `/saef:7-release`
  - `en` = English only
  - `ja` = Japanese only
  - `ja-en` = Both languages (bilingual)

### Integration Arguments (Not Yet Implemented)

> [!CAUTION]
> These arguments are defined in the command interface but not yet implemented.

- **`--productboard <id1,id2,...>`** - Pull ProductBoard context (only in `/saef:1-refine`)
- **`--shortcut <id1,id2,...>`** - Pull Shortcut context (only in `/saef:1-refine`)

### Testing Status

> [!NOTE]
> **Validated**: Commands 1-5 (`/saef:1-refine` through `/saef:5-implement`) have been tested in production.

> [!WARNING]
> **Experimental** 🧪:
> - Commands 6-7 (`/saef:6-docs`, `/saef:7-release`) are defined but not yet fully validated
> - Skills: `soracom-shortcut-lifecycle`, `soracom-screenshot-generator`, `soracom-diagram-generator`

### Important Notes

> [!IMPORTANT]
> **`/saef:5-implement`**: Does NOT push branches or create PRs. User handles `git push` and PR creation manually.

> [!NOTE]
> **`/saef:6-docs`**: Only needed for user-facing documentation. Internal features may skip this.
>
> **`/saef:7-release`**: Only needed for public changelog announcements.

---

## Debug Commands

Tools for analyzing and improving SAEF workflows.

| Command | Purpose | Output |
|---------|---------|--------|
| `/saef:debug:review-session` | Analyze session for systemic improvements | `outputs/session_reviews/<name>-session-analysis.md` |

This command assesses your session, provides a summary of challenges encountered, suggests improvements, and outputs a complete task list to address issues. After analysis, it can offer to implement the improvements immediately and create a PR description following the template.

Useful when:
- You encountered issues or friction during the workflow
- You want to provide feedback to improve SAEF
- You discovered patterns that could help others

---

## Skills Reference

Specialized knowledge modules that guide the AI.

Skills are knowledge modules in `.claude/skills/`. Each skill has a `SKILL.md` file with frontmatter (name, description, allowed-tools) and detailed instructions. Claude Code discovers and loads skills automatically based on context.

| Skill | Purpose |
|-------|---------|
| **saef-ops** | Core utilities: `init-feature.sh`, `check-context.sh`, screenshot helpers |
| **soracom-backend-guidelines** | OpenAPI standards, backend patterns, release workflow |
| **soracom-changelog-writer** | Bilingual changelog drafts |
| **soracom-diagram-generator** | Mermaid/PlantUML diagrams from SAEF artifacts |
| **soracom-documentation-writer** | Documentation for website-users (JP Hugo) and website-developers (EN Grav) |
| **soracom-frontend-guidelines** | SDS components, accessibility, i18n |
| **soracom-github-lifecycle** | Branch naming, PR checklist, review workflow |
| **soracom-release-lifecycle** | Deployment workflow, Nebula promotion |
| **soracom-repository-catalog** | Repository discovery from `docs/repositories.yaml` |
| **soracom-screenshot-generator** | E2E screenshot organization and annotation from CI/CD |
| **soracom-shortcut-lifecycle** | Shortcut ticket management and linking |
| **soracom-testing-guidelines** | Test strategy, Root vs SAM testing, 80% coverage requirements |

---

## Hooks

Automated quality checks and formatting.

Hooks run automatically after tool use to maintain quality and validate context.

| Hook | Event | Purpose |
|------|-------|---------|
| `markdown_formatter.py` | `PostToolUse` (Edit\|Write) | Adds missing language tags to code fences, normalizes blank lines |
| `check_context_guardrail.sh` | `PostToolUse` (SlashCommand) | Validates required artifacts exist before each `/saef:*` command |

Hooks are configured in [.claude/settings.json](.claude/settings.json).

---

## Test Scenarios

Sample feature ideas for validating the workflow.

### Internal Console Features

- View PUK on subscriber page
- Logically group configurations on operator page
- Show Snowflake charts on operator and subscriber pages
- View SIM status history on subscriber page
- Show session ID in session events table on subscriber page
- Show average session duration for last N hours on subscriber page
- Show session duration per session in deleted session event rows
- Logically regroup accordion sections into sub-sections on operator and subscriber pages
- Update roaming configuration OTA campaigns section to accurately reflect campaign status and offer actions
- Create a SIM page with SIM ID/ICCID records and nested subscribers; update operator page with SIMs list
- Make session events table columns filterable (already sortable)
- Search for multiple ICCIDs or IMSIs at once and receive all results
- Add all Soracom services to the internal console so staff can view customer service usage for support and assistance

### User Console Features

- Allow customers to open support tickets directly and select resources/alerts to discuss
- Add in-app notifications for incidents, warning banners, and error-log alerts
- Add last known IMEI as a column on SIM Management page
- Allow customers to close their account mid-billing-cycle with correct prorations

### Backend/Billing Features

- Add additional columns to subscriber session tables to expose missing metadata
- Send proactive renewal reminder emails before subscription renewal fees
- Add professional services offering to billing system as a billable product

---

## Future Directions

Ideas under consideration for future development.

- Slack bot or MCP server: Make `/saef:1-refine` available as a Slack bot or MCP server so people can capture feature ideas without needing Claude Code or an IDE
- MCP server integration: Connect to ProductBoard, Shortcut, Slack, and GitHub for context retrieval
- Claude rule system: Explore using Claude's rule system for additional context and guardrails
- PR feedback analysis: Review recent PRs to learn from implemented features and incorporate feedback patterns into guidance
- Backtesting validation: Check out pre-merge branch states, run SAEF with same prompts, compare output against actual implementations to validate system quality without real-time use
- Parallel implementation: Run implementation across multiple repos concurrently
- Multiple flows: Feature flow (current), product flow (larger initiatives), internal tool flow (using soracom/starfox template)
- Fine-tuning from usage: Improve prompts based on session reviews
- Work orchestration: Workload planning and cross-feature coordination

---

## Contributing

I welcome contributions and feedback.

### Found an Issue?

If you encounter a problem:
1. Run `/saef:debug:review-session` to generate a session analysis
2. The command will offer to implement improvements and create a PR description
3. Alternatively, create an issue or reach out to **@rein** on Slack with the analysis file

### Want to Improve SAEF?

1. Clone this repository
2. Create a feature branch from `main`
3. Make your changes
4. Test your changes with real SAEF workflows
5. Submit a pull request using the [PR template](.github/pull_request_template.md)

**Code ownership**: See [.github/CODEOWNERS](.github/CODEOWNERS) for review assignments.
