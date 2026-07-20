# Security audit log

This app records security-sensitive authentication and account events in a dedicated
`security_events` table for incident traceability.

## Event types

| Event | When |
|---|---|
| `login.success` | Successful sign-in via `SignIn.call` |
| `login.failure` | Failed password sign-in (known or unknown email) |
| `login.lockout` | Account locked after too many failed attempts |
| `logout` | User signs out |
| `admin.impersonation.start` | Admin starts "Login as" a participant |
| `admin.impersonation.stop` | Admin returns from impersonation |
| `password.changed` | Password updated via profile, admin participant edit, or admin signup |
| `password.reset` | Password reset completed via reset token |

Each event stores event type, subject account, actor account, IP address, user agent,
JSON metadata, and timestamp. Passwords and tokens are never persisted in metadata.

## Admin index

Admins can review events at `/admin/security_events` (read-only Datagrid with filters
for event type and date range).

## Code

- Model: [`app/models/security_event.rb`](../app/models/security_event.rb)
- Logger: [`app/services/security_event_logger.rb`](../app/services/security_event_logger.rb)
- Admin UI: [`app/controllers/admin/security_events_controller.rb`](../app/controllers/admin/security_events_controller.rb)

## Out of scope (future work)

- Admin IP allowlist blocked-access events
- Inactive admin deactivation events
- Logging of general admin CRUD actions beyond the event types above
