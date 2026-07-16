---
name: push-pr-issue
description: Push the current issue branch and create a GitHub pull request with an explicit user approval gate before any push. Embeds verification screenshots/GIFs in the PR body by default when evidence exists under tmp/issue-<N>-*/.
---

# Push Branch And Create PR

Push the current issue branch to `origin` and create a pull request on GitHub. This skill always asks for explicit user approval before pushing.

When verification evidence exists locally, **embed proofs in the PR body by default** — do not leave bare `tmp/...` paths (those do not render on GitHub).

## Prerequisites

- Current branch matches `<type>/<issue-number>-<slug>` (for example `feat/5602-block-ambassador-judge-access`).
- There is at least one local commit to publish.
- `gh` CLI is installed and authenticated.
- Working tree is clean before pushing.
- **`gh-image` extension** (for embedded screenshots/GIFs): `gh extension install drogers0/gh-image`. If missing, install once before Step 2; if install or upload fails, fall back to the release-asset method in Step 2 or note the gap in the PR body.

## Inputs

Parse from context and the current repo state:

- **Base branch** (default: `qa`)
- **PR title/body** (derive from commit history + issue title unless user gives explicit text)
- **Issue number** from branch name
- **PR body source** (optional) — path to `ship-ledger.md` when called from `ship-issue` Stage 10
- **PR number** (optional) — when the branch is already pushed and the user only wants to create or update a PR

## Workflow

Copy this checklist and track progress:

```
- [ ] Step 1: Inspect branch status
- [ ] Step 2: Draft PR title/body (include proofs by default)
- [ ] Step 3: Push-approval gate (required)
- [ ] Step 4: Push branch to origin
- [ ] Step 5: Create or update PR with gh
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
- If there are no commits ahead to publish **and** no existing PR to update, stop.

### Step 2: Draft PR title/body

Gather context:

```bash
gh issue view <N> --json title,url
git log --oneline origin/<base>..HEAD
git diff --stat origin/<base>...HEAD
```

**Evidence discovery (run before drafting the body):**

1. If the caller passed a **PR body source** (e.g. `tmp/issue-<N>-<slug>/ship-ledger.md`), read it first.
2. Otherwise, locate the newest evidence directory for this issue:

   ```bash
   ls -td tmp/issue-<N>-*/ 2>/dev/null | head -1
   ```

3. Collect proof artifacts in that directory (and `frames/` subdirs):

   ```bash
   find tmp/issue-<N>-*/ -maxdepth 2 \( -name '*-before.png' -o -name '*-after.png' -o -name '*-action.gif' \) 2>/dev/null | sort
   ```

**Upload proofs for GitHub rendering** (local `tmp/` paths are not viewable in PR descriptions):

Preferred in interactive dev (browser logged into GitHub) — `gh-image` (produces `user-attachments` URLs, same as drag-and-drop):

```bash
gh extension install drogers0/gh-image   # once per machine

BEFORE_MD=$(gh image tmp/issue-<N>-<slug>/01-<context>-before.png)
AFTER_MD=$(gh image tmp/issue-<N>-<slug>/01-<context>-after.png)
```

If `gh image` hangs or errors (common without a browser session cookie), use the **release-asset fallback** instead — works with standard `gh auth login`:

```bash
TAG="pr-<N>-evidence-$(date +%s)"
gh release create "$TAG" tmp/issue-<N>-<slug>/*.{png,gif} \
  --title "PR #<N> verification evidence" \
  --notes "Auto-generated evidence for PR review." \
  --prerelease
# Build markdown from .assets[].browser_download_url via gh api
```

If no evidence directory exists, omit `## Evidence` — do not invent placeholders.

**Default PR body structure** (use ship-ledger sections when available):

```markdown
## Summary
- <1-3 bullets from commits / ledger>

Closes #<N>

## Test plan
- [x] <commands run, from ledger or implement-plan>

## Acceptance criteria
- [x] <AC item> — <embedded before/after images when UI proof exists>

## Evidence
### <context> (e.g. off-season splash)
<uploaded BEFORE_MD>
<uploaded AFTER_MD>
```

Rules:

- **Always include `## Summary`** (1-3 bullets).
- **Include `## Test plan`** when tests were run (ship-issue / verify-fix-evidence runs).
- **Include `## Acceptance criteria` and `## Evidence` with embedded images** when `tmp/issue-<N>-*/` contains screenshots or GIFs — this is the default, not opt-in.
- Pair before/after stills under descriptive `###` headings; add action GIFs on the same AC row when present.
- When updating an existing PR (`gh pr edit`), merge new evidence into the body rather than dropping prior sections.

### Step 3: Push-approval gate (required)

**Autonomous override:** If the caller is running in autonomous mode (e.g. `ship-issue --auto`) or the user explicitly requested no push approval, skip the `AskQuestion` gate below. Log the branch name, base branch, commits to publish, and draft PR title/body, then proceed directly to Step 4.

**Interactive mode (default):** Before any push, present:

- Branch name
- Base branch
- Commits to publish
- Draft PR title/body (note which proof images will be embedded)

Use AskQuestion with options:

- `Push and create PR`
- `Edit PR text`
- `Cancel`

Do not continue without explicit approval.

**Post-commit shortcut:** When the user runs the diff-tab **commit-and-push** action and then asks to **create PR** (or says "create pr"), treat that as push approval for this branch and proceed — still embed proofs if evidence exists.

### Step 4: Push branch to origin

Skip if `origin/<branch>` already contains the commits to publish.

```bash
git push -u origin HEAD
```

Never use force push in this skill.

### Step 5: Create or update PR with gh

Create:

```bash
gh pr create --base <base> --title "<title>" --body "$(cat <<'EOF'
<body with embedded proof markdown>
EOF
)"
```

Update existing PR (branch already pushed):

```bash
gh pr edit <number> --body "$(cat <<'EOF'
<body with embedded proof markdown>
EOF
)"
```

If proofs were uploaded after the initial `gh pr create`, run `gh pr edit` immediately so the description contains rendered images, not `tmp/` paths.

### Step 6: Return clickable PR link

Return the created or updated PR URL and a Markdown clickable link:

```markdown
PR created: [<title>](<url>)
```

Mention how many proof images/GIFs were embedded.

## Hard rules

- Never push without explicit user approval in Step 3, except when the autonomous override applies (caller is `ship-issue --auto`, user explicitly requested no push approval, or user asked to create PR after commit-and-push). Step 1 blockers still apply in all modes.
- Never use `--force`, `--force-with-lease`, or `--no-verify`.
- Never rewrite git history.
- Never create more than one PR per invocation.
- **Never put bare `tmp/issue-...` paths in the PR body when uploadable PNG/GIF files exist** — embed via `gh image` or release-asset URLs.
- Do not commit evidence files to the repo solely for PR rendering unless the user explicitly requests that approach.
