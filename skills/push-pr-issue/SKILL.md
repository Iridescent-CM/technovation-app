---
name: push-pr-issue
description: Push the current issue branch and create a GitHub pull request with an explicit user approval gate before any push.
---

# Push Branch And Create PR

Push the current issue branch to `origin` and create a pull request on GitHub. This skill always asks for explicit user approval before pushing.

## Prerequisites

- Current branch matches `<type>/<issue-number>-<slug>` (for example `feat/5602-block-ambassador-judge-access`).
- There is at least one local commit to publish.
- `gh` CLI is installed and authenticated.
- Working tree is clean before pushing.

## Inputs

Parse from context and the current repo state:

- **Base branch** (default: `qa`)
- **PR title/body** (derive from commit history + issue title unless user gives explicit text)
- **Issue number** from branch name

## Workflow

Copy this checklist and track progress:

```
- [ ] Step 1: Inspect branch status
- [ ] Step 2: Draft PR title/body
- [ ] Step 3: Push-approval gate (required)
- [ ] Step 4: Push branch to origin
- [ ] Step 5: Create PR with gh
- [ ] Step 6: Return clickable PR link
```

### Step 1: Inspect branch status

Run:

```bash
git branch --show-current
git status --porcelain
git rev-list --left-right --count origin/<base>...HEAD
```

Blockers:

- If branch name does not match issue pattern, stop and ask user.
- If working tree is dirty, stop and ask user to commit/stash first.
- If there are no commits ahead to publish, stop.

### Step 2: Draft PR title/body

Gather context:

```bash
gh issue view <N> --json title,url
git log --oneline origin/<base>..HEAD
git diff --stat origin/<base>...HEAD
```

Draft:

- Title: concise, issue-aligned.
- Body:
  - `## Summary` only (1-3 bullets).
  - Do not include `## Test plan` or `Evidence` sections unless the user
    explicitly asks for them.

### Step 3: Push-approval gate (required)

**Autonomous override:** If the caller is running in autonomous mode (e.g. `ship-issue --auto`) or the user explicitly requested no push approval, skip the `AskQuestion` gate below. Log the branch name, base branch, commits to publish, and draft PR title/body, then proceed directly to Step 4.

**Interactive mode (default):** Before any push, present:

- Branch name
- Base branch
- Commits to publish
- Draft PR title/body

Use AskQuestion with options:

- `Push and create PR`
- `Edit PR text`
- `Cancel`

Do not continue without explicit approval.

### Step 4: Push branch to origin

```bash
git push -u origin HEAD
```

Never use force push in this skill.

### Step 5: Create PR with gh

```bash
gh pr create --base <base> --title "<title>" --body "$(cat <<'EOF'
<body>
EOF
)"
```

### Step 6: Return clickable PR link

Return the created PR URL and a Markdown clickable link:

```markdown
PR created: [<title>](<url>)
```

## Hard rules

- Never push without explicit user approval in Step 3, except when the autonomous override applies (caller is `ship-issue --auto` or user explicitly requested no push approval). Step 1 blockers still apply in all modes.
- Never use `--force`, `--force-with-lease`, or `--no-verify`.
- Never rewrite git history.
- Never create more than one PR per invocation.
