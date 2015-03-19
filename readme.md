# Readme

## Quick Start

Assuming Rails, Postgres, rbenv, and bundler are all installed...

``` sh
git clone https://github.com/Iridescent-CM/technovation-app.git
cd technovation-app
rbenv install
bundle install
createdb technovation_development
rake db:migrate
echo HOST_DOMAIN=localhost:3000 > .env
rake db:seed
rails s
```

then navigate to http://localhost:3000

Initial credentials are in [`./db/seeds.rb`](blob/master/db/seeds.rb) to log in.

## Signatures

Users are required to have a signature on file before doing anything. On registration, an HMAC-signed url is sent to the parent's email for signature. Once the signature button is clicked, the user is then able to perform actions on the site.  In case a url needs to be manually generated and sent, use `rake signature:link[id]` where `id` is the user's numerical id.

## Administration

The administration panel can be reached at '/admin'. From there, users, teams, and various settings can be added, editing, and removed.

### Settings

There are two major settings that must be present for the application to run correctly.

1. *year*: All teams will be created with this year as its season. The team index will also default to showing teams created in this year.
2. *cutoff* A user's age for division cutoff (high-school, middle-school) will be calculated based on this date.

From within the irb, type:
s = Setting.new(key: 'cutoff', value: Date.today.to_s)
s.save!
s = Setting.new(key: 'year', value: '2015')

### Announcements

Announcements can be created in the dashboard with the "New Announcement" button under the "Announcements" tab in the administration page.  An announcement must be published before it will show up on the participant's dashboards.

### Authentication

Admin panel at /admin
admin@example.com
password

### Third party
Attachments handled via Paperclip
https://github.com/thoughtbot/paperclip

Forms are handled with
https://github.com/bootstrap-ruby/rails-bootstrap-forms

### Environment variables

- `SKIP_CHECKR`: Set to `true` to skip the background check API call. Useful for development and staging environments.

