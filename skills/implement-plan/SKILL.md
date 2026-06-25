---
name: implement-plan
description: Implement a feature from a Cursor plan file produced by the CreatePlan tool. Use when the user asks to implement, build, execute, run, or start a plan - especially right after a plan was created by a planning skill like plan-github-issue. Stops before any git commit so the user can review.
---
# Implement Plan

Turn a finalized Cursor plan into working code. This skill picks up where planning skills (e.g. `plan-github-issue`) leave off, edits the files the plan calls for, and runs targeted tests. It stops before committing - the user reviews and commits.

## Inputs

Parse from the user's message:

- **Plan file path** (optional) - a full path, or a filename under `~/.cursor/plans/` or the workspace `.cursor/plans/`.
- **Issue / topic reference** (optional) - e.g. `issue #4053`, `the back-to-scores plan`, used to disambiguate when several recent plans exist.

If the user gives nothing, look for a plan file already referenced earlier in the conversation. If still ambiguous, list candidate plans and ask which to implement via AskQuestion.

## Hard rules

- Implementation-only - do **not** create a new plan, and do **not** add tasks the plan does not list.
- **Never** create a git commit, push, or open a PR. Stop after tests run and report status.
- Stay within the "Affected code" / "Approach" scope of the plan. If you discover something material the plan missed, stop and surface it to the user instead of silently expanding scope.
- If plan mode is active, call `SwitchMode` to `agent` before editing non-markdown files.

## Workflow

Copy this checklist and track progress as you go:

```
- [ ] Step 1: Locate the plan file
- [ ] Step 2: Parse plan + todos
- [ ] Step 3: Mirror todos into TodoWrite
- [ ] Step 4: Implement each todo
- [ ] Step 5: Run targeted tests
- [ ] Step 6: Report status (no commit)
```

### Step 1: Locate the plan file

Try in this order:

1. Path given by the user.
2. Plan file already referenced in this conversation (e.g. the most recent `CreatePlan` output - its path was returned as `/Users/.../.cursor/plans/<name>_<hash>.plan.md`).
3. Newest `*.plan.md` under `~/.cursor/plans/` and the workspace `.cursor/plans/`:

   ```bash
   ls -t ~/.cursor/plans/*.plan.md .cursor/plans/*.plan.md 2>/dev/null | head -5
   ```

If multiple candidates look plausible, list them (filename + title from the first heading) and ask via AskQuestion which to implement.

### Step 2: Parse plan + todos

Read the plan file in full. Extract:

- **Affected code** - the files you're allowed to touch.
- **Approach** - the step-by-step actions.
- **Tests** - the test files to run / extend (used in Step 5).
- **Rollout** - migrations, feature flags, i18n, docs to update.
- **Out of scope** - things you must NOT touch.
- The plan's `todos` (from frontmatter) and the body's `## Approach` numbered list.

**Required sections.** `## Out of scope` and `## Acceptance criteria` are mandatory. If either is missing from the plan, stop and report — do not proceed without a scope fence or an AC list. `none` is an acceptable value for `Out of scope` but the section header must be present.

**Todos handoff.** Read both the `todos` field from the plan's frontmatter AND the body's `## Approach` numbered list. If both are empty, stop and report — there is nothing to implement against.

### Step 3: Mirror todos into TodoWrite

Create one `TodoWrite` item per todo from the plan, preserving wording. Mark the first as `in_progress`. Update statuses as you progress through Step 4.

### Step 4: Implement each todo

For each todo:

0. **Pattern check.** Before the first edit in a directory you have not touched in this run, list 2-3 sibling files and skim one to learn the local convention (file layout, naming, helper usage, test style). Cite the file you used as a model in your final status report under "Pattern modeled on:". Skip this when editing a file you've already read in this run.
1. `Read` the target file(s) before editing.
2. Make the edit described in the plan (`StrReplace` / `Write` / `EditNotebook` as appropriate). Match existing indentation and style.
3. After substantive edits, call `ReadLints` on the touched files and fix any lint errors you introduced (do not chase pre-existing ones).
4. Mark the todo `completed` and move to the next.

If the plan calls for behaviour the existing code does not support, stop and report rather than inventing scope.

### Step 5: Run targeted tests

**AC → test mapping first.** Before running anything, list each acceptance criterion from the plan's `## Acceptance criteria` and the test (or planned screenshot for UI-visible AC) that exercises it. Use the plan's `## Tests` section as the canonical list of files. If any AC item has no backing test and no planned screenshot, **stop and report** — do not write a tautological test against the code you just wrote. Coverage must come from the AC, not from the diff.

Then run the listed test files (`## Tests` section) plus any spec files clearly covering the source files you changed. Detect the test runner from the repo:

- Rails / RSpec: `bundle exec rspec <files>` (use `bin/rspec` if present).
- Node + Jest: `npx jest <files>` (or the script defined in `package.json`).
- Node + Vitest: `npx vitest run <files>`.
- Python + pytest: `pytest <files>`.

Do **not** run the full suite unless the plan explicitly asks for it.

**Retry budget.** If a spec fails, fix the issue (within plan scope) and re-run. Cap retries at **two fix attempts per failing spec file**. After the second failed attempt, stop and surface the failing assertion with the source line. Never insert `skip`, `pending`, `xit`, `xdescribe`, or equivalent to make a failure go away.

If tests fail for reasons clearly outside the plan (pre-existing failures, infrastructure), stop and report.

### Step 6: Report status

Print a short summary:

- Files changed (paths as markdown links).
- Tests run and their outcome.
- Any deviations from the plan and why.
- Next steps for the user, e.g. "review the diff, then commit when ready".

Do **not** run `git add`, `git commit`, `git push`, or `gh pr create`.

## Output rules

- Cite changed files with markdown links to their workspace paths.
- Keep the final summary tight - 5-10 bullets max.
- Never invent additional refactors or "while we're here" cleanups.

## Next step

After the status report, suggest the user invoke `code-review` against the diff and, for user-visible changes, `verify-fix-evidence` to capture browser screenshots. Do not auto-invoke them. For the orchestrated end-to-end flow, see the `ship-issue` skill.
