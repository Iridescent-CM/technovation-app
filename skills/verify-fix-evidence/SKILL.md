---
name: verify-fix-evidence
description: Verify a code change against the issue's acceptance criteria by mapping each AC item to a before/after screenshot pair (for static UI items), a before/after pair plus an animated GIF (for action-based UI items), or a test (for non-UI items), capturing numbered evidence into tmp/issue-<N>-<fix-slug>/, and re-running the modified test files. Use when the user asks to verify the fix, capture evidence, prove this works, take screenshots, record the action, capture a GIF, or demonstrate that a bug is resolved.
---

# Verify Fix Evidence

Verifies a change against the issue's acceptance criteria. Builds an AC checklist, maps each static UI AC item to a before/after Chromium screenshot pair, each action-based UI AC item to a before/after pair plus an animated GIF, and each non-UI AC item to a test, captures evidence into `tmp/issue-<N>-<fix-slug>/`, re-runs the affected test files, and emits a report that maps every AC item to clickable proof links.

## Seed accounts

For role-specific verification on the technovation-app dev environment, log in via `/sessions` with these seeded accounts (password equals email in every case):

| Role | Email |
|------|-------|
| Student | `student@student.com` |
| Mentor | `mentor@mentor.com` |
| Chapter ambassador | `chapter-ambassador@chapter-ambassador.com` |
| Judge | `judge@judge.com` |
| Admin | `admin@admin.com` |

There is **no seeded club-ambassador account**. If the AC requires that role, stop and ask the user to either create one or explicitly skip that role's evidence with a note in the final report.

Confirm via `browser_snapshot` that the logged-in account matches the planned role before capturing role-specific views; a screenshot under the wrong role does not prove anything.

## Animated evidence tooling

For action-based UI evidence, prefer the existing `cursor-ide-browser` workflow: take a short burst of real screenshots around the action and stitch those frames into a GIF.

Use `gifski` when available, with `ffmpeg` as a fallback:

```bash
command -v gifski || brew install gifski
command -v ffmpeg || brew install ffmpeg
```

If neither tool is available and installation is declined, keep the ordered frame sequence under `tmp/issue-<N>-<fix-slug>/frames/NN-<context>/` and note in the report that a GIF could not be generated.

Alternative backends when the screenshot-burst approach is not enough:

- **Playwright native video**: add Playwright as a dev dependency, install Chromium with `npx playwright install chromium`, record the real interaction as video, and convert to GIF with `ffmpeg`. This gives the smoothest action capture but adds a new browser stack and a small login/harness script.
- **Capybara/Selenium frames**: use the app's existing `selenium_chrome_headless` system-test stack to drive the action, dump `page.save_screenshot` frames, and stitch those frames into a GIF. This reuses test infrastructure, but do not write new verification specs in this stage; new tests belong in `implement-plan`.

## Workflow

Copy this checklist and track progress as you go:

```
- [ ] Step 1: Build the AC checklist
- [ ] Step 2: Map each AC item to a screenshot pair, action GIF, or test
- [ ] Step 3: Pick a fix slug + create the evidence directory
- [ ] Step 4: Capture the before state (UI-visible AC items only)
- [ ] Step 5: Capture the after state (UI-visible AC items only)
- [ ] Step 6: Re-run the modified test files
- [ ] Step 7: Emit the verification report
```

### Step 1: Build the AC checklist

Locate the plan file under `~/.cursor/plans/` or the workspace `.cursor/plans/` for this fix and read its `## Acceptance criteria` section. If no plan is available, fetch the issue (`gh issue view <N> --comments --json body,comments,title,url`) and extract AC from the body and comments.

Emit the AC items as an explicit checklist before doing anything else:

```
AC for #<N>:
- [ ] AC1: <verbatim or de-duplicated bullet>
- [ ] AC2: ...
- [ ] AC3: ...
```

If you cannot find an AC section in the plan and the issue body has no list-like statement of expected behavior, stop and ask the user. Do not invent ACs.

### Step 2: Map each AC item to a screenshot pair, action GIF, or test

For each AC item, decide its proof path:

- **Static UI** (button appears, page renders, copy changes, visible state changes without needing to prove motion) → produce a **before/after screenshot pair** in Steps 4–5.
- **Action UI** (click feedback, redirect after submit, modal opens/closes, animation, drag/drop, menu expansion, form submission flow) → produce a **before/after screenshot pair** plus an **action GIF** in Step 5.
- **Non-UI** (model method, job behavior, service result, controller status code without observable view change) → name the test file that exercises it; that file will be re-run in Step 6.

If any AC item has neither a planned screenshot pair / action GIF nor a backing test, **stop and report**. Do not invent screenshots, do not fabricate GIF frames, do not pad with cosmetic captures, and do not write a fresh test from this stage (that belongs in `implement-plan`).

### Step 3: Pick an evidence directory

Evidence directory: `tmp/issue-<N>-<fix-slug>/`.

- `<N>`: the GitHub issue number, without `#`.
- `<fix-slug>`: short, kebab-case, descriptive. Examples: `back-to-scores`, `mentor-invite-error`, `judge-score-validation`.
- Example full directory names: `tmp/issue-123-back-to-scores/`, `tmp/issue-456-mentor-invite-error/`.

```bash
mkdir -p tmp/issue-<N>-<fix-slug>/
```

For Action UI items, also use a frames directory named after the still-pair number and context:

```
tmp/issue-<N>-<fix-slug>/frames/NN-<context>/
```

Only intermediate frame screenshots go in `frames/`; the final `NN-<context>-action.gif` goes at the evidence directory root next to the before/after stills.

Skip this step if there are zero UI-visible AC items (Steps 4–5 will be no-ops).

### Step 4: Capture the before state

Capture the UI state **before** the fix by stashing the in-progress changes so the working tree matches `origin/qa`. Do this **only for UI-visible AC items**.

1. Stash all uncommitted changes (including untracked files):

   ```bash
   git stash push -u -m "verify-before-issue-<N>-<fix-slug>"
   ```

2. Use the `cursor-ide-browser` MCP tools to navigate to each UI-visible view:
   - Follow the same lock/navigate/snapshot rules as Step 5.
   - Authenticate as the appropriate role from the Seed accounts table and confirm identity.
   - For each UI-visible AC item, capture with `browser_take_screenshot` saved to:

     ```
     tmp/issue-<N>-<fix-slug>/NN-<context>-before.png
     ```

   - The dev server reloads Rails views and controllers automatically; JS/asset-only changes may need a rebuild for the before state to differ visually — note this if relevant.

3. Restore the fix immediately after all before shots are captured:

   ```bash
   git stash pop
   git status --short
   ```

4. **Hard rule:** if `git stash pop` fails or `git status` shows the tree does not match its pre-stash state, STOP and report the exact error — never leave the fix stashed and never continue to Step 5 with a broken working tree.

5. If the tree was already clean before Step 4 (fix already committed when run standalone): capture the before state by checking out the changed files at `origin/qa` temporarily, shoot, then restore with `git checkout HEAD -- <files>`. If this is not feasible, note in the report that the before state could not be reproduced and continue with after shots only.

### Step 5: Capture the after state

With the fix restored (working branch or working tree with uncommitted changes), capture the UI state **after** the fix. These mirror the views shot in Step 4.

Use the `cursor-ide-browser` MCP tools. Rules:

1. List existing tabs with `browser_tabs` action `list` to see what is already open.
2. Lock / navigate ordering:
   - If no relevant tab exists, call `browser_navigate` first, then `browser_lock` action `lock`.
   - If a tab already exists, call `browser_lock` action `lock` first, then navigate or interact.
3. Before any interaction, call `browser_snapshot` to obtain refs. Refresh the snapshot after any structural change (navigation, click, form submission, dialog).
4. Authenticate as the role under test using the **Seed accounts** table above. Verify the logged-in identity in the snapshot before capturing.
5. For each UI-visible AC item from Step 2, capture with `browser_take_screenshot` saved to:

   ```
   tmp/issue-<N>-<fix-slug>/NN-<context>-after.png
   ```

   - `NN`: zero-padded 2-digit sequence (`01`, `02`, ...) — **must match the pair number used in Step 4**.
   - `<context>`: who is acting and where, kebab-case (e.g. `mentor-scores-index`, `student-score-detail`, `admin-team-edit`).

   Canonical pair examples:
   - `01-mentor-scores-index-before.png` / `01-mentor-scores-index-after.png`
   - `02-mentor-score-detail-with-back-button-before.png` / `02-mentor-score-detail-with-back-button-after.png`

6. For each Action UI item from Step 2, capture a real screenshot burst around the action and stitch it into a GIF:
   - Use `browser_snapshot` to obtain the action element ref immediately before the action.
   - Create the frames directory if it does not exist:

     ```bash
     mkdir -p tmp/issue-<N>-<fix-slug>/frames/NN-<context>/
     ```

   - Capture the ordered frame sequence with `browser_take_screenshot`: capture `frame-01.png`, perform the action (for example `browser_click`), capture `frame-02.png` immediately, wait only as needed for the UI to settle, then capture `frame-03.png`.

     ```
     tmp/issue-<N>-<fix-slug>/frames/NN-<context>/frame-01.png   # pre-action
     tmp/issue-<N>-<fix-slug>/frames/NN-<context>/frame-02.png   # immediately after click / mid-transition
     tmp/issue-<N>-<fix-slug>/frames/NN-<context>/frame-03.png   # settled state
     ```

   - Add more frames (`frame-04.png`, `frame-05.png`, ...) when the interaction has multiple visible states. Keep the sequence short and AC-focused.
   - Stitch the frames into a GIF named with the same `NN` and `<context>` as the still pair:

     ```bash
     gifski --fps 3 -o tmp/issue-<N>-<fix-slug>/NN-<context>-action.gif \
       tmp/issue-<N>-<fix-slug>/frames/NN-<context>/frame-*.png

     # fallback
     ffmpeg -y -framerate 3 -pattern_type glob \
       -i 'tmp/issue-<N>-<fix-slug>/frames/NN-<context>/frame-*.png' \
       -vf "scale=1000:-1:flags=lanczos" \
       tmp/issue-<N>-<fix-slug>/NN-<context>-action.gif
     ```

   - If the bug is the action itself misbehaving before the fix, optionally capture a before-action GIF while in Step 4 and name it `NN-<context>-before-action.gif`; otherwise the after-action GIF is enough because the still pair already proves before/after state.
   - If GIF generation is unavailable, keep the numbered frames and list them as a gap in the report.
7. When all after screenshots and action GIFs are captured, call `browser_lock` action `unlock`.
8. If a step is blocked (login MFA, captcha, ambiguous UI, missing test data) and the same approach has failed twice, stop and report. Do not loop.

### Step 6: Re-run the modified test files

Identify the test files modified in this run (from the diff or from the `## Tests` section of the plan) plus any test files mapped to non-UI AC items in Step 2. Re-run them with the project's runner:

- Rails / RSpec: `bundle exec rspec <files>` (use `bin/rspec` if present).
- Node + Jest: `npx jest <files>` (or the script defined in `package.json`).
- Node + Vitest: `npx vitest run <files>`.
- Python + pytest: `pytest <files>`.

This is a re-run for verification, not a re-implementation. If any test fails here, **stop and report**. Do not patch the fix from this stage; that belongs in `implement-plan`.

If no test files were modified and there are no non-UI AC items, note "no tests to re-run" in the report.

### Step 7: Emit the verification report

Every screenshot, GIF, and frame path in the report must be a relative Markdown link so the artifact is clickable in Cursor. Use descriptive link text and the full relative path as the target:

```markdown
[before screenshot](tmp/issue-<N>-<fix-slug>/01-<context>-before.png)
[after screenshot](tmp/issue-<N>-<fix-slug>/01-<context>-after.png)
[action GIF](tmp/issue-<N>-<fix-slug>/01-<context>-action.gif)
```

Do not put evidence artifacts only in backticks in the final report; backticks are fine for test file paths and commands.

```markdown
## Verified
<1-3 sentences on what was demonstrated>

## Acceptance criteria
- [x] AC1: <text> — [before screenshot](tmp/issue-<N>-<fix-slug>/01-...-before.png) / [after screenshot](tmp/issue-<N>-<fix-slug>/01-...-after.png)
- [x] AC2: <action text> — [before screenshot](tmp/issue-<N>-<fix-slug>/02-...-before.png) / [after screenshot](tmp/issue-<N>-<fix-slug>/02-...-after.png) plus [action GIF](tmp/issue-<N>-<fix-slug>/02-...-action.gif)
- [x] AC3: <text> — re-ran `spec/foo_spec.rb` (passed)
- [ ] AC4: <text> — not verified (<reason>)

## Tests re-run
- `spec/foo_spec.rb` — passed (N examples)
- `spec/bar_spec.rb` — passed (M examples)

## Evidence
- [01 before screenshot](tmp/issue-<N>-<fix-slug>/01-...-before.png) — <what this shows before the fix>
- [01 after screenshot](tmp/issue-<N>-<fix-slug>/01-...-after.png) — <what this proves after the fix>
- [02 before screenshot](tmp/issue-<N>-<fix-slug>/02-...-before.png) — <what this shows before the fix>
- [02 after screenshot](tmp/issue-<N>-<fix-slug>/02-...-after.png) — <what this proves after the fix>
- [02 action GIF](tmp/issue-<N>-<fix-slug>/02-...-action.gif) — <what interaction this proves after the fix>
- [02 action frames](tmp/issue-<N>-<fix-slug>/frames/02-.../) — <only list when GIF generation failed or the frames add useful context>

## Not verified / gaps
- <unchecked AC items and why, or "none">
```

The pipeline (`ship-issue` Stage 7) treats this stage as **incomplete** if any AC item in the checklist is unchecked. Surface gaps explicitly; do not auto-tick boxes that were not proven.

## Anti-patterns

- Before/after screenshot pairs are **required** for every UI-visible AC item — post-fix-only screenshots are not acceptable.
- Action-based UI AC items require an action GIF **in addition to** the before/after still pair; the GIF does not replace the stills.
- GIFs must be stitched from real captured frames of the UI action. Do not fabricate frames or create illustrative animations.
- Do not pad with cosmetic captures that are not mapped to an AC item.
- All artifacts go under `tmp/issue-<N>-<fix-slug>/` — never elsewhere.

## Next step

This is the final stage of the plan / implement / review / verify pipeline. After the verification report, the user reviews the screenshots and decides when to commit. For the orchestrated end-to-end flow, see the `ship-issue` skill.
