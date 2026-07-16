# Brute-force and password-spray protection

This app limits repeated authentication attempts at two layers.

## IP throttling (rack-attack)

| Endpoint | Limit |
|---|---|
| `POST /signins` | 20 requests per IP per 60 seconds |
| `POST /password_resets` | 5 requests per IP per 60 seconds |

Exceeded limits return HTTP **429 Too Many Requests** with a generic message.

Counters are stored in `Rails.cache` (Memcached in production). Localhost is safelisted in development only.

## Per-account lockout

| Setting | Value |
|---|---|
| Failed attempts before lockout | 10 |
| Lockout duration | 30 minutes |

After 10 failed password attempts on `POST /signins`, the account is locked. Locked accounts cannot sign in until the lockout window expires. A successful sign-in (via password or any path that calls `SignIn.call`) resets the counter and clears lockout.

Failed attempts that do not yet lock the account show how many attempts remain and highlight the password-reset link. Blank passwords do not increment the failure counter. The Sign In button stays disabled until a password is entered.

Unknown email addresses still receive the generic sign-in error and do not increment any counter.

## Configuration

- Rack::Attack: [`config/initializers/rack_attack.rb`](../config/initializers/rack_attack.rb)
- Account lockout: [`app/models/account.rb`](../app/models/account.rb) (`MAX_FAILED_ATTEMPTS`, `LOCKOUT_PERIOD`)

## Out of scope (future work)

- MFA / Active Directory
- CAPTCHA
- Admin unlock UI or unlock-via-email
- Cloudflare WAF rules
