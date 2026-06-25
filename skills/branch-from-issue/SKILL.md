---
name: branch-from-issue
description: >-
  Create a new local git branch off `origin/qa` named after a GitHub issue,
  using the format `<prefix>/<issue-number>-<2-4-word-slug>` (for example
  `feat/1111-judge-dashboard-fix`). The prefix is picked from the issue's
  labels (`feat/`, `fix/`, `chore/`). Use when the user asks to create a
  branch from a GitHub issue, start work on an issue, branch off qa for
  issue #N, or says things like "make a branch for issue 1234".
---

# Branch from GitHub Issue

Create a local working branch off the latest `origin/qa` named after a GitHub issue.

The deliverable is a clean checkout on a new branch named like:

```
feat/1111-judge-dashboard-fix
fix/2034-login-redirect-loop
chore/987-bump-rails
```

This skill never edits application code.

## Prerequisites

- `gh` CLI installed and authenticated. Verify with `gh auth status`. If missing/unauthenticated, tell the user to run `brew install gh && gh auth login` and stop.
- Inside a git repo with an `origin` remote that has a `qa` branch. Confirm with `git ls-remote --heads origin qa`. If absent, ask the user which base branch to use and stop.

## Inputs

Parse from the user's message:

- **Issue number** (required) - accept `#123`, `123`, `GH-123`, or a URL like `https://github.com/owner/repo/issues/123`.
- **Repo** (optional) - if the user gives `owner/repo` or a GitHub URL, pass `--repo owner/repo` to `gh`. Otherwise rely on `gh`'s auto-detection.
- **Prefix override** (optional) - if the user explicitly says "use fix/" or "as a chore", honor that and skip label-based detection.

If the issue number cannot be determined, ask the user via AskQuestion before doing anything else.

## Workflow

Copy this checklist and track progress:

```
- [ ] Step 1: Verify clean working tree
- [ ] Step 2: Fetch the issue
- [ ] Step 3: Build the slug (2-4 words)
- [ ] Step 4: Pick the prefix
- [ ] Step 5: Update origin/qa
- [ ] Step 6: Create and checkout the branch
- [ ] Step 7: Confirm to the user
```

### Step 1: Verify clean working tree

```bash
git status --porcelain
```

If output is non-empty, stop and ask the user whether to stash, commit, or abort. Do not silently lose work.

### Step 2: Fetch the issue

```bash
gh issue view <N> [--repo owner/repo] --json number,title,labels,state,url
```

If the issue is closed, warn the user and ask whether to continue.

### Step 3: Build the slug (2-4 words)

From the issue title, produce a kebab-case slug of **2-4 meaningful words**.

Rules:

1. Strip leading tag prefixes like `[Bug]`, `[Feature]`, `BUG:`, `Feature -`, `Story:`.
2. Lowercase the title.
3. Remove punctuation; keep `a-z`, `0-9`, and spaces.
4. Drop stop words: `a`, `an`, `the`, `of`, `to`, `for`, `in`, `on`, `with`, `and`, `or`, `is`, `are`, `be`, `that`, `this`, `it`, `as`, `at`, `by`, `from`, `should`, `when`.
5. Keep the first 2-4 remaining words that best convey the topic. Prefer nouns and verbs that appear in the issue (you may pick non-leading words if the leading ones are filler).
6. Join with `-`. Trim trailing hyphens.
7. Max length 40 characters; truncate at a word boundary if needed.

**Examples:**

| Title | Slug |
|-------|------|
| `[Bug] Judge dashboard crashes when switching from chapter ambassador` | `judge-dashboard-crashes` |
| `Feature: Add club ambassador switch-to-judge flow` | `club-ambassador-switch-judge` |
| `Bump Rails to 7.2` | `bump-rails` |
| `Fix login redirect loop on QA` | `login-redirect-loop` |

### Step 4: Pick the prefix

Inspect `labels[*].name` from Step 2.

| Label contains (case-insensitive) | Prefix |
|-----------------------------------|--------|
| `bug`, `defect`, `regression` | `fix` |
| `chore`, `refactor`, `tech-debt`, `dependencies` | `chore` |
| anything else, or no labels | `feat` |

If the user explicitly overrode the prefix in their message, use that instead.

### Step 5: Update origin/qa

```bash
git fetch origin qa
```

Do **not** modify the user's local `qa` branch - branch directly off the remote ref.

### Step 6: Create and checkout the branch

Final branch name: `<prefix>/<issue-number>-<slug>` (e.g. `feat/1111-judge-dashboard-fix`).

Before creating, check whether it already exists locally:

```bash
git rev-parse --verify --quiet <branch> && echo "exists"
```

If it exists, ask the user whether to checkout the existing branch, pick a different slug, or abort.

Otherwise create and switch to it:

```bash
git checkout -b <branch> origin/qa
```

### Step 7: Confirm to the user

Report back in this exact shape:

```
Branch created: <branch>
Base:           origin/qa @ <short-sha>
Issue:          #<N> - <issue title> (<url>)
```

Then stop. Do not start implementation work - that is a separate skill (`implement-plan` or `ship-issue`).

## Examples

**Example 1**

User: `branch off qa for issue #1111`

Issue title: `[Bug] Judge dashboard crashes when switching from chapter ambassador`
Labels: `["bug", "judge"]`

Result: `fix/1111-judge-dashboard-crashes`

**Example 2**

User: `start work on https://github.com/teamtechnovation/technovation-app/issues/2034`

Issue title: `Add club ambassador switch-to-judge flow`
Labels: `["enhancement"]`

Result: `feat/2034-club-ambassador-switch-judge`

**Example 3**

User: `make a chore branch for 987 - bump rails to 7.2`

Issue title: `Bump Rails to 7.2`
Labels: `["dependencies"]`
Explicit override: `chore`

Result: `chore/987-bump-rails`

## Output rules

- Never modify application code; this skill only touches branch state.
- Never force-push, rebase, or delete branches.
- Never run `git reset --hard` or `git clean`.
- If anything is ambiguous (dirty tree, missing `qa`, duplicate branch name), stop and ask via AskQuestion.
