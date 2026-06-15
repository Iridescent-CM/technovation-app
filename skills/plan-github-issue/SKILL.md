---
name: plan-github-issue
description: >-
  Plan the implementation of a GitHub issue by issue number. Fetches the issue
  and its comments via the gh CLI, explores the repo for relevant code, and
  produces a concrete implementation plan via CreatePlan. Use when the user
  asks to plan, scope, or design the implementation of a GitHub issue / ticket
  by number (for example "plan issue #123", "plan GH 456", "scope ticket #789").
---

# Plan GitHub Issue

Turn a GitHub issue into a concrete implementation plan. This skill stops at the plan - it never edits application code.

## Prerequisites

Requires the `gh` CLI, authenticated. Verify with `gh auth status`. If `gh` is missing or unauthenticated, tell the user to run `brew install gh && gh auth login` and stop.

## Inputs

Parse from the user's message:

- **Issue number** (required) - accept `#123`, `123`, `GH-123`, or a full URL like `https://github.com/owner/repo/issues/123`.
- **Repo** (optional) - if the user gives `owner/repo` or a GitHub URL, pass `--repo owner/repo` to `gh`. Otherwise rely on `gh`'s auto-detection from the current workspace's git remote.

If the issue number cannot be determined, ask the user for it via AskQuestion before doing anything else.

## Workflow

Copy this checklist and track progress as you go:

```
- [ ] Step 1: Fetch the issue
- [ ] Step 2: Fetch linked PRs/issues
- [ ] Step 3: Extract requirements
- [ ] Step 4: Explore the repo
- [ ] Step 5: Resolve ambiguity and expected result
- [ ] Step 6: Produce the plan via CreatePlan
```

### Step 1: Fetch the issue

```bash
gh issue view <N> [--repo owner/repo] --comments --json number,title,state,labels,assignees,body,comments,url,milestone,projectItems,closedByPullRequestsReferences
```

### Step 2: Fetch linked PRs / issues

Scan the body and comments for `#NNN` references, `owner/repo#NNN`, and PR / issue URLs. Fetch the most relevant ones (cap ~5) with `gh pr view <N> --comments` or `gh issue view <N> --comments`.

### Step 3: Extract requirements

From the issue + comments, pull out:

- Problem statement (1-3 sentences in your own words)
- Acceptance criteria (de-duplicated bullets)
- Explicit file / function / API / route references
- Open questions, blockers, decisions still pending

### Step 4: Explore the repo

Use Grep / Glob / SemanticSearch with identifiers and nouns from the issue (file paths, class names, route names, error message fragments). Read the 3-8 most relevant files. Prefer parallel searches.

### Step 5: Resolve ambiguity and expected result

Before drafting the plan, make sure you fully understand the expected result from the user's perspective. If anything material is ambiguous - e.g. the desired user-visible behavior, which of two subsystems to touch, whether breaking changes are acceptable, which API version to target, or how to interpret incomplete acceptance criteria - ask as many focused questions as needed with AskQuestion. Continue this clarify-and-reassess loop until the expected result, constraints, and success criteria are clear enough to produce an implementation plan. Do not ask cosmetic questions.

### Step 6: Produce the plan

Call `CreatePlan` using the template below. This is the deliverable - do not make code edits.

**Required arguments to `CreatePlan`:**

- `plan`: the markdown body (template below). Every section is required; write `none` rather than omitting.
- `todos`: a non-empty list of `{id, content}` items derived 1:1 from the body's `## Approach` numbered list. Each todo's `content` names the file or change scope so `ship-issue` Stage 9 can group commits per todo. Do not omit `todos`; `implement-plan` reads them as the canonical worklist and stops if both `todos` and `## Approach` are empty.

## Plan template

Pass this structure to `CreatePlan`. Fill in real content. Every section is required; if a section genuinely does not apply, write `none` rather than dropping it.

```markdown
# Issue #<N>: <Issue title>

## Context
- Issue: <url>
- Status / labels / milestone
- 2-3 sentence summary of the problem in your own words

## Acceptance criteria
- Bullet list pulled (and de-duplicated) from issue body + comments

## Affected code
- `path/to/file.rb` - what changes and why
- `path/to/other.tsx` - what changes and why

## Approach
1. Step 1...
2. Step 2...

## Tests
- New / updated tests and where they live (file paths). `implement-plan`
  re-runs these in Step 5; `verify-fix-evidence` may re-run them again.

## Rollout
- Migrations: `none` | `reversible` | `needs backfill` | `concurrent index`
- Feature flag: `<name>` or `none`
- i18n keys touched: `<list>` or `none`
- Docs / changelog: `none` | `needs update` (which file)

## Risks & open questions
- ...

## Out of scope
- ... (write `none` if everything in the issue is being handled)
```

## Output rules

- Always end by calling `CreatePlan` - that is the deliverable.
- Cite code references using the existing-code citation syntax (`startLine:endLine:filepath`).
- Quote short, relevant excerpts from the issue body / comments rather than re-pasting the whole issue.
- Never modify application files. This skill is planning-only.

## Next step

After `CreatePlan` returns, this skill stops. The user can land the changes by invoking the `implement-plan` skill (e.g. "implement the plan"), which picks up the plan file and edits code. For the full pipeline through review and browser evidence, see the `ship-issue` skill.
