# Readme

### BUILD
[![Build Status](https://snap-ci.com/VZFas7ngsZ1NZNRdEmOsk2V-ZtOXuB3wJcXsdzL3jj0/build_image)](https://snap-ci.com/Iridescent-CM/technovation-app/branch/master)

https://snap-ci.com/Iridescent-CM/technovation-app/branch/master

### Environments
**QA:** https://technovation-qa.herokuapp.com/

**STAGING:** https://technovation-staging.herokuapp.com/

### Database (required)
[Install PostgreSQL](#pg-install)

### ImageMagick (required)
[Install ImageMagick](#im-install)

### Project Setup
``` sh
git clone https://github.com/Iridescent-CM/technovation-app.git
cd technovation-app
rbenv install
gem install bundler
bundle install

bundle exec rake db:setup
cp .env.example .env
```

### Environment variables

- `HOST_DOMAIN`: Configure the App Host. Used for URLs sent in e-mails.
- `SKIP_CHECKR`: Set to `true` to skip the background check API call. Useful for development and staging environments.


### Seed up your development environment
The app use [spring](https://github.com/rails/spring) and [spring-command-rspec](https://github.com/jonleighton/spring-commands-rspec) to speed up the development, to install use: 

``` sh
bundle exec spring binstub --all
bundle exec spring binstub rspec
```

### Run App
``` sh
bundle exec rails server
```
then navigate to http://localhost:3000

Initial credentials are in [`./db/seeds.rb`](blob/master/db/seeds.rb) to log in.


### Run tests
``` sh
bundle exec rspec
```

### Run Database
``` sh
./start_db.sh
```

## Signatures

Users are required to have a signature on file before doing anything. On registration, an HMAC-signed url is sent to the parent's email for signature. Once the signature button is clicked, the user is then able to perform actions on the site.  In case a url needs to be manually generated and sent, use `rake signature:link[id]` where `id` is the user's numerical id.

## Administration

The administration panel can be reached at '/admin'. From there, users, teams, and various settings can be added, editing, and removed.

For create a admin user, execute:

``` sh
bundle exec rails runner "AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')"
```


For `development` environment the default credentials are:


**user**: `admin@example.com` 
**pass**: `password`


### Settings

There are several major settings that must be present for the application to run correctly.

1. *year*: All teams will be created with this year as its season. The team index will also default to showing teams created in this year.
2. *cutoff* A user's age for division cutoff (high-school, middle-school) will be calculated based on this date.
3. *submissionOpen* *submimssionClose* The dates that user submissions should open and close. Dates formatted as 2015-02-03
4. *quarterfinalJudgingOpen* *quarterfinalJudgingClose* *semifinalJudgingOpen* *semifinalJudgingClose* *finalJudgingOpen* *finalJudgingClose* The dates that various rounds of judging open and close. These are used to determine whether a particular rubric created was for the quarterfinal, semifinal, or final round of judging.
5. *quarterfinalScoresVisible* *semifinalScoresVisible* *finalScoresVisible* A true or false value indicating whether scores from these rounds are visible to teams.

For existing databases, the code for generating these settings can be copy-pasted from db/seeds.rb into a rails console. Settings can be edited from the admin panel.

### Announcements

Announcements can be created in the dashboard with the "New Announcement" button under the "Announcements" tab in the administration page.  An announcement must be published before it will show up on the participant's dashboards.


### <a id="pg-install"> Install PostgreSQL 9.3</a>
``` sh
brew update
brew install  homebrew/versions/postgresql93
```
#### Create a PostgreSQL instance
``` sh
pg_ctl -D /usr/local/pgsql/data initdb
```

#### Initialize Database
``` sh
pg_ctl -D /usr/local/pgsql/data start
```

### <a id="im-install"> Install ImageMagick</a>
So that Paperclip works properly, you need to install ImageMagick. ImageMagick resizes thumbnails images. For more information click <a href="https://github.com/thoughtbot/paperclip">here.</a>
``` sh
brew install imagemagick
```
