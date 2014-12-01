# Readme

## Signatures
Users are required to have a signature on file before doing anything. On registration, an HMAC-signed url is sent to the parent's email for signature. Once the signature button is clicked, the user is then able to perform actions on the site.  In case a url needs to be manually generated and sent, use `rake signature:link[id]` where `id` is the user's numerical id.

## Administration

The administration panel can be reached at '/admin'. From there, users, teams, and various settings can be added, editing, and removed.

### Settings

There are two major settings that must be present for the application to run correctly.

1. *year*: All teams will be created with this year as its season. The team index will also default to showing teams created in this year.
2. *cutoff* A user's age for division cutoff (high-school, middle-school) will be calculated based on this date.

- Deploy Instructions

