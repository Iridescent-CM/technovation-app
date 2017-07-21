# Technovation Challenge Platform

QA: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa)

Master: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master)

Production: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production)

## ORACLE RHoK PARTICIPANTS

Use the [Dropbox
link](https://www.dropbox.com/s/rz6eeajncjt2veq/sanitized_technovation_psql_data.sql?dl=0) to download the sample, sanitized data

## Installation and Setup

### Prerequisites

Install linuxbrew dependencies

```
sudo apt-get install build-essential curl file git python-setuptools ruby
```

Install linuxbrew

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
```

```
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.bash_profile
```

Install qt5

```
sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
```

Intsall elasticsearch

```
brew install elasticsearch
brew services start elasticsearch
```

Install postgresql

```
brew install postgresql
```

Install redis

```
brew install redis
```

Install pdftk

```
sudo apt-get install pdftk
```

Install rbenv

```
brew install rbenv
```

Install ruby 2.4.1

```
rbenv install 2.4.1
```

Download [this .env.rhok file](https://www.dropbox.com/s/8yih4rf0z68ba9i/.env.rhok?dl=0) and rename it to `.env`

### Install the rails application

```
git clone git@gitlab.com:technovationmx/technovation-rails.git
cp <PATH_TO_RHOK_ENV> technovation-rails
cd technovation-rails
rbenv local 2.4.1
./bin/setup
```

Restore local database with sample, sanitized database

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U <USERNAME> -d technovation-app_development <PATH_TO_SQLFILE>
```

Seed / bootstrap the DB

```
rails db:seed bootstrap
```

## User type logins:

* Student
  * username: student@student.com
  * password: student@student.com
* Mentor
  * username: mentor@mentor.com
  * password: mentor@mentor.com
* Judge
  * username: judge@judge.com
  * password: judge@judge.com
* Regional Ambassador
  * username: ra@ra.com
  * password: ra@ra.com
* Admin
  * username: rhok@oracle.com
  * password: rhokdemo

## To turn on/off various user features:

  * Login as the admin
  * Go to "Season Schedule Settings"
  * Toggle what you need on or off

## Development server

```
rails s
```

**Visit http://localhost:3000 in your favorite web browser**

## Tests

TechnovationApp uses RSpec, and you can run the entire test suite just by entering the command `rake`

```
rake
```
