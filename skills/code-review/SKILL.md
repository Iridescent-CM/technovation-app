---
name: code-review
description: Review code for correctness, security, readability, performance, and test coverage, with general best practices first and a Rails-specific section for Ruby on Rails projects (RSpec, Pundit, ActiveRecord N+1, Stimulus/Turbo, StandardRB, Brakeman). Use when the user asks for a code review, says "review this", looks at a PR/diff, or asks for feedback on a change.
---

# Code Review

Guides the agent through a structured code review. The general section applies to any language; the Rails section adds project-aware checks for Ruby on Rails apps.

## Quick-start workflow

1. Identify the surface to review: the staged/unstaged diff, a specific PR, or a set of files the user pointed at. If unclear, ask once.
2. Read the full diff, then read each changed file plus its immediate callers/callees and any tests touching the changed code. Do not start commenting from the diff alone.
3. If a verification toolchain is available, run the relevant subset and capture output:
   - Ruby/Rails: `bundle exec rspec <paths>`, `bundle exec standardrb`, `bin/brakeman -q --no-pager` for security-sensitive changes.
   - JavaScript: `npx eslint <paths>` and `npx prettier --check <paths>`.
   - Skip tools that are not configured; do not invent commands.
4. Draft findings, group by severity, and deliver them using the output template below.

Do not make code changes during a review unless the user explicitly asks; the deliverable is feedback, not edits.

## Severity labels

Every finding uses one of:

- `Critical` - must fix before merge: bugs, security holes, data loss, broken or missing tests for new behavior, breaking API changes.
- `Important` - should fix: meaningful performance regressions, missing edge-case handling, unclear naming with real risk of misuse, missing authorization checks.
- `Suggestion` - nice to have: refactors, clearer abstractions, minor duplication.
- `Nit` - cosmetic: wording, ordering, trivial style not enforced by linters.

If a finding does not clearly fit `Critical` or `Important`, it is probably `Suggestion` or `Nit`.

## General checklist

Apply judgment, not exhaustive coverage. Focus on what the diff actually changes.

- Correctness and edge cases: nil/empty/zero/negative inputs, off-by-one, time zones, concurrency, idempotency, partial failures.
- Error handling: failures surface with useful context; no silent `rescue` swallowing real errors; user-facing errors do not leak internals.
- Security: authentication and authorization on every new entry point; input validation and output encoding; no secrets in code or logs; safe deserialization; SSRF/XSS/SQLi/path-traversal where applicable; safe file uploads and redirects.
- Readability: names describe intent; functions are cohesive and reasonably small; dead code removed; comments explain non-obvious why, not what.
- Performance: avoid accidental O(n^2), unnecessary I/O in loops, large allocations on hot paths; cache only when justified.
- Tests: new branches and edge cases are covered; assertions are meaningful; mocks reflect real contracts; no flakiness sources (`sleep`, real network, time-of-day dependence).
- Backwards compatibility and migrations: schema and API changes are reversible and safe to deploy incrementally; feature flags or staged rollouts where appropriate.
- Documentation: changelog/README/inline docs updated when behavior or interfaces change.

## Rails-specific section

Apply when the changed files include `app/`, `config/`, `db/`, `lib/`, `spec/`, or related Rails paths.

- Authorization (Pundit): every controller action has `authorize` or `policy_scope`; new policies have matching `spec/policies/...` coverage; do not bypass policies in concerns.
- ActiveRecord: watch for N+1 (use `includes` / `preload` / `eager_load`); use `find_each` for large sets; use scopes over inline `where`; always use parameter binding (`where("col = ?", x)`), never string interpolation; rely on `bullet` in dev/test to surface N+1.
- Migrations: reversible (`change` or paired `up`/`down`); add indexes for new foreign keys and frequent lookups; for large tables use `disable_ddl_transaction!` with `add_index ..., algorithm: :concurrently`; avoid destructive changes without a backfill plan.
- Strong params and mass-assignment: every `params.require(...).permit(...)` lists only safe attributes; sensitive fields (role, owner_id, confirmed_at, etc.) are never mass-assignable from user input.
- Domain logic: prefer service objects or POROs over fat controllers and large `before_save`/`after_save` callback chains; callbacks are predictable and side-effect-light.
- ERB views: use `t(".key")` for i18n (this app uses `rails-i18n`/`i18n-js`); avoid logic in views (extract to helpers/presenters); never render raw user content without `sanitize` or escaping; prefer `link_to` / `button_to` with proper HTTP verbs.
- Stimulus / Turbo / JavaScript: prefer Stimulus controllers and Turbo Frames/Streams over new jQuery code; use `data-controller` / `data-*-target` / `data-action` conventions; keep controllers small; ESLint + Prettier must be clean.
- Background jobs (Sidekiq): jobs are idempotent and retry-safe; pass record IDs (not ActiveRecord instances) as arguments; set explicit `sidekiq_options` for retry/dead-set behavior on jobs that should not retry indefinitely.
- File uploads (Carrierwave): validate content type and size; sanitize filenames; do not trust client-provided MIME types alone.
- Style: defer to `standardrb` for Ruby and `prettier` for JS/CSS; do not bikeshed anything those tools already enforce. Only flag style when it harms clarity.
- Security tooling: recommend running `bin/brakeman` for changes touching auth, redirects, raw SQL, file uploads, deserialization, or `send`/`constantize` on user input.
- Specs: prefer request and system specs for behavior; keep `factory_bot` factories minimal and use traits for variants; use `vcr`/`webmock` for external HTTP; never use `sleep` in Capybara - use Capybara's matchers, which auto-wait; avoid `eq` on time values without normalization.

## Output format template

Deliver every review using this structure. Omit empty severity sections.

```markdown
## Summary
<2-4 sentences: what changed, overall impression, recommended next step>

## Findings
### Critical
- `path/to/file.rb:42` - <issue in one line> - <concrete fix>

### Important
- `path/to/file.rb:88` - ...

### Suggestions
- ...

### Nits
- ...

## Tests
<coverage assessment, missing cases, flakiness risks>

## Verification run
<commands run and outcomes, or "not run because ...">
```

Always cite file paths and line numbers using inline backticks so they are clickable. When suggesting a fix, prefer a concrete sketch over an abstract directive.

## Anti-patterns in reviews

- Do not narrate what the code does line by line; assume the author knows their code.
- Do not bikeshed style that `standardrb` or `prettier` already enforces.
- Do not demand changes without giving a reason or a concrete alternative.
- Do not pad reviews with `Suggestion` items to look thorough; if the diff is fine, say so.
- Do not block on personal preference; mark it `Nit` and move on.

## Next step

If the diff includes user-visible behavior (UI, redirects, mailers, JS), suggest the user invoke `verify-fix-evidence` to capture browser screenshots that prove the change. Do not auto-invoke it. For the orchestrated end-to-end flow, see the `ship-issue` skill.
