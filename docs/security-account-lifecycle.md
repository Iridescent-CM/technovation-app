# Admin account lifecycle

Admin accounts are subject to password expiration and inactivity deactivation.

## Password expiration

- Column: `accounts.password_changed_at` (stamped whenever `password_digest` changes)
- Max age: **90 days** (`Account::ADMIN_PASSWORD_MAX_AGE`)
- Scope: accounts with an `admin_profile` only
- Enforcement: `AdminController` redirects expired admins to `/admin/password` until they set a new password (20-character admin complexity rules apply)
- Existing rows are backfilled to “now” on migrate so deploy does not mass-expire passwords

## Inactive admin deactivation

- Column: `accounts.deactivated_at`
- Threshold: **90 days** without login (`Account::ADMIN_INACTIVITY_DEACTIVATION_AFTER`)
- Inactivity signal: `COALESCE(last_logged_in_at, created_at)`
- Job: `Admin::DeactivateInactiveAccounts` via rake task `deactivate_inactive_admins`
- On deactivation: sets `deactivated_at`, regenerates `auth_token` (invalidates cookies), logs `admin.deactivated`
- Sign-in, admin portal, and Sidekiq web access refuse deactivated accounts
- Super-admins can reactivate from `/admin/admins` (clears `deactivated_at`, regenerates `auth_token`, logs `admin.reactivated`)

## Scheduler

There is no in-app cron. Schedule the rake task externally (e.g. Heroku Scheduler) to run daily:

```bash
bundle exec rake deactivate_inactive_admins
```

## Related code

- Model helpers: [`app/models/account.rb`](../app/models/account.rb)
- Service: [`app/services/admin/deactivate_inactive_accounts.rb`](../app/services/admin/deactivate_inactive_accounts.rb)
- Rake: [`lib/tasks/deactivate_inactive_admins.rake`](../lib/tasks/deactivate_inactive_admins.rake)
- Forced password UI: [`app/controllers/admin/passwords_controller.rb`](../app/controllers/admin/passwords_controller.rb)

## Related issues

- [#6313](https://github.com/Iridescent-CM/technovation-app/issues/6313) — persistent accounts without expiration / deactivation
