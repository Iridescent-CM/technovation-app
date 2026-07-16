# Password policy

This document describes the Technovation platform password policy and planned future authentication work.

## Current policy (enforced server-side)

Password complexity is validated on **Account** (registration, profile change, admin first-time setup) and on the **Password** reset form object.

### Regular users (students, mentors, judges, ambassadors, parents)

- Minimum **8 characters**
- At least one **uppercase** letter
- At least one **lowercase** letter
- At least one **digit**
- Must **not** contain the email local-part (the part before `@`)

### Platform administrators (`temporary_password` status)

- Minimum **20 characters**
- Same complexity rules as regular users (uppercase, lowercase, digit; no email local-part)
- Admin onboarding UI recommends generating passwords with password-management software

### What is not enforced

- Special characters are allowed but not required
- Password strength meters in registration UI are advisory; server validation is authoritative
- Existing accounts are **not** forced to rotate passwords until their next change or reset

## Implementation

- Validator: `app/validators/password_complexity_validator.rb`
- Wired on `Account` and `Password` models alongside existing length validations
- Auto-generated invite passwords for new admins (`inviting_new_admin`) skip complexity validation because they are never user-facing

## Future phase (out of scope)

The following items are **not** implemented in the current stack and are deferred to a later security phase:

### Multi-factor authentication (MFA)

Technovation uses email + password sign-in via `SigninsController` and `has_secure_password`. There is no TOTP, SMS, or WebAuthn flow today. MFA would require new enrollment UX, backup codes, and sign-in flow changes.

### Active Directory / SSO

There is no OmniAuth, SAML, or Azure Entra ID integration. Enterprise SSO would require identity-provider configuration, account linking, and migration strategy for existing local accounts.

### Related issues

- [#6308](https://github.com/Iridescent-CM/technovation-app/issues/6308) — password policy hardening (this work)
- [#6309](https://github.com/Iridescent-CM/technovation-app/issues/6309) — brute-force / password-spray protection
- [#6313](https://github.com/Iridescent-CM/technovation-app/issues/6313) — account expiration / deactivation
