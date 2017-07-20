# Technovation Challenge Platform

QA: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa)

Master: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master)

Production: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production)

## ORACLE RHoK PARTICIPANTS

Use the [Dropbox
link](https://www.dropbox.com/s/rz6eeajncjt2veq/sanitized_technovation_psql_data.sql?dl=0) to download the sample, sanitized data

## Installation and Setup

### Prerequisites

You **must** install `qt5` for the gem `capybara-webkit` to install:

https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit

You **must** install `elasticsearch`

```
brew install elasticsearch
brew services start elasticsearch
```

You **must** install `postgresql`

```
brew install postgresql
```

You **must** install `redis server`

```
brew install redis
```

You **must** install `pdftk`

Find your download and install from
https://www.pdflabs.com/tools/pdftk-server/

### Setup

Set your Ruby version with your favorite ruby version management tool **(RVM, rbenv, chruby, etc)** to:

`Use Ruby Version: 2.4.1`

Request sensitive keys from your teammates for the `.env` file.

### ORACLE RHoK PARTICIPANTS:

Download [this .env.rhok file](https://www.dropbox.com/s/8yih4rf0z68ba9i/.env.rhok?dl=0) and rename it to `.env`

You will need to provide your own info for AWS and possibly other 3rd party services

### Install the rails application

```
git clone git@github.com:Iridescent-CM/technovation-app.git
cd technovation-app
*** GET THE SENSITIVE INFO FROM DEV TEAM FOR .env FILE ***
*** ORACLE: See directly above ***
echo "PDFTK_PATH=`which pdftk`" >> .env
./bin/setup
```

### ORACLE RHoK PARTICIPANTS:

  * Restore local database with sample, sanitized database
    * `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U <USERNAME> -d technovation-app_development <PATH_TO_SQLFILE>`
  * Run `rails bootstrap`

## Turn on/off various user features:

  * Login as the admin
    * username: `rhok@oracle.com`
    * password: `rhokdemo`
  * Go to "Season Schedule Settings"
  * Toggle what you need on or off

## Drop / recreate / re-seed / re-bootstrap  database

```
rails db:drop db:create db:migrate && rails db:seed bootstrap
```


## Copy data from production (don't be reckless with the data!)

```
dropdb technovation-app_development
heroku pg:pull DATABASE_URL technovation-app_development --app technovation
```

## Development server

```
rails server
```

**Visit http://localhost:3000 for the web**

## Tests

TechnovationApp uses RSpec

```
rake
```

## Rake tasks

```
rails db:seed 
# Seeds with a student, a couple of mentors, and an admin for manual testing
```

```
rails bootstrap
# Adds the Technovation expertises for mentors to choose for their profile
# Adds the Technovation admin account
```

## Release to production

For current version, see [VERSION](VERSION)

Release next patch (ex: 2.45.5 -> 2.45.6)
```
rails release
```

Release next minor (ex: 4.32.8 -> 4.33.0)
```
rails release minor
```

Release next major (ex: 2.59.8 -> 3.0.0)
```
rails release major
```
