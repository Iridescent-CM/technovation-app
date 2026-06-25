---
name: commit-issue
description: >-
  Stage and commit changes on an issue branch with a one-line Conventional
  Commits message aligned to the branch prefix (`feat:`, `fix:`, `chore:`)
  and the issue number as the scope. No body, no footer. Shows the drafted
  message for user approval, then runs a single `git commit`. Never pushes.
  Use when the user asks to commit the changes, finalize the issue with a
  commit, or says "commit this", "make the commit", "wrap up issue #N
  with a commit".
---

# Commit Issue Changes

Stage and commit the current working changes on an issue branch using a one-line Conventional Commits message that mirrors the branch prefix and uses the issue number as the scope. No body, no footer. Stops after the commit; never pushes.

## Prerequisites

- Currently on a branch named like `<type>/<issue-number>-<slug>` (the format produced by `branch-from-issue`, e.g. `feat/1111-judge-dashboard-crashes`). If the branch does not match, stop and ask the user how to proceed.
- There are staged or unstaged changes. If `git status --porcelain` is empty, stop and tell the user there is nothing to commit.
- `gh` CLI authenticated (used to fetch the issue title for the commit subject if not already known).

## Inputs

Mostly derived from the current branch. Override only if the user explicitly provides them:

- **Type** - from branch prefix (`feat`, `fix`, `chore`). If the prefix is none of those, ask the user which Conventional Commits type to use.
- **Issue number** - from the branch name (`<type>/<N>-<slug>`).
- **Scope** (optional) - the user may pass one (e.g. "scope: judge"); otherwise derive from changed paths (see below) or omit.
- **Subject** (optional) - if the user provides one, use it verbatim.

## Workflow

Copy this checklist and track progress:

```
- [ ] Step 1: Inspect branch + working tree
- [ ] Step 2: Gather diff context
- [ ] Step 3: Fetch issue title
- [ ] Step 4: Draft the commit message
- [ ] Step 5: Get user approval
- [ ] Step 6: Stage + commit
- [ ] Step 7: Report the commit
```

### Step 1: Inspect branch + working tree

```bash
git branch --show-current
git status --porcelain
```

Parse the branch as `^(feat|fix|chore)/(\d+)-(.+)$`. If it does not match, stop. If the tree is clean, stop.

### Step 2: Gather diff context

```bash
git diff --stat HEAD
git diff HEAD
```

Use the file list and diff to inform the subject line: "added X", "fixed Y", "refactored Z". Keep the detail in your head — the commit is one line, so any narrative belongs in the PR description, not here.

### Step 3: Fetch issue title

```bash
gh issue view <N> --json title,url
```

This gives the canonical title for use in the subject (after cleanup).

### Step 4: Draft the commit message

**Format (Conventional Commits):**

```
<type>(<issue-number>): <subject>
```

Always use the **subject line only** form above — no body, no footer, no trailers. The issue number lives in the scope (e.g. `feat(5602): ...`); that's how the commit is linked to the ticket. The PR description is the place for narrative. Do not add a body. Do not add a `Refs #<N>` / `Closes #<N>` footer; if the user explicitly asks for context, push back and direct it to the PR description instead.

Rules:

1. **Type** comes from the branch prefix (`feat` / `fix` / `chore`).
2. **Scope** is the issue number, taken from the branch name (`<type>/<N>-<slug>` → `(N)`). If a commit on an issue branch genuinely has no relationship to the issue (e.g. an incidental local-env fix), omit the scope rather than fake one. The user may override (e.g. "use `judge` as the scope") and you must honor that.
3. **Subject**:
   - Imperative mood, lowercase first letter, no trailing period.
   - ≤ 72 characters.
   - Summarize the *change*, not the issue. Strip `[Bug]`/`Feature:` prefixes from the issue title.
4. **No body, no footer, no trailers.** Never add a `Refs #<N>` / `Closes #<N>` footer, a `[plan: ...]` trailer, or any other trailer, even if the user asks — the issue number in the scope already links the commit. Narrative belongs in the PR description.

**Examples**

Branch `fix/1111-judge-dashboard-crashes`:

```
fix(1111): handle nil current_account in dashboard switch
```

Branch `feat/2034-club-ambassador-switch-judge`:

```
feat(2034): add club-ambassador switch-to-judge flow
```

Branch `chore/987-bump-rails`:

```
chore(987): bump Rails to 7.2
```

Branch `feat/5602-block-ambassador-judge-access`, incidental env-only fix unrelated to #5602:

```
chore: support local arm64-darwin dev environment
```

### Step 5: Get user approval

**Autonomous override:** If the caller is running in autonomous mode (e.g. `ship-issue --auto`) or the user explicitly requested no commit approval, skip the `AskQuestion` gate below. Log the drafted message and file list, then proceed directly to Step 6.

**Interactive mode (default):** Show the drafted message and the file list via AskQuestion:

```
Drafted commit:
---
<full message>
---
Files staged:
  M app/controllers/judge_controller.rb
  M spec/controllers/judge/dashboards_controller_spec.rb
  ...
```

Offer three options:
- "Commit as drafted"
- "Edit the message" (user provides revised text; redraft and re-confirm)
- "Cancel"

Do not proceed without explicit approval.

### Step 6: Stage + commit

Check whether files are already staged:

```bash
git diff --cached --name-only
```

- **If the output is non-empty**, commit only those staged files. **Do not** run `git add` to expand the set; the caller (typically `ship-issue` Stage 9) staged exactly what should go into this commit.
- **If the output is empty**, fall back to standard behavior: stage all tracked changes plus new files the user wants included. Confirm before adding any file that looks sensitive (`.env`, `*.pem`, `credentials*`, `secrets*`); skip it if the user does not explicitly confirm.

  ```bash
  git add <files>
  ```

Then commit:

```bash
git commit -m "$(cat <<'EOF'
<full message>
EOF
)"
```

The HEREDOC form keeps quoting consistent with the rest of the toolchain even though the message is a single line.

If a pre-commit hook fails, surface the failure and stop. Do not retry with `--no-verify`. Do not amend; fix the issue and let the user re-invoke the skill for a new commit.

### Step 7: Report the commit

```bash
git log -1 --pretty=fuller
git status
```

Report back in this exact shape, then stop:

```
Committed: <short-sha> on <branch>
Subject:   <subject line>
Files:     <count>
```

The caller decides what comes next (typically `push-pr-issue` when run from `ship-issue`, or whatever the user invokes manually).

## Hard rules

- Never run `git push`, `git push --force`, or `gh pr create`. This skill stops at the local commit.
- Never use `git commit --amend`, `git reset`, or `git rebase`.
- Never use `--no-verify` to bypass hooks.
- Never modify `.git/config` or any git config.
- Never commit files that look like secrets without explicit user confirmation — even in autonomous mode. The Step 5 autonomous override does not waive the Step 6 secret-file confirmation; stop and ask if sensitive files would be staged.
- One commit per invocation. If the user wants multiple commits, run the skill multiple times.
