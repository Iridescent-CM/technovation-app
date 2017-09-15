# Technovation Challenge Platform

QA: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa)

Master: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master)

Production: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production)

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
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.bash_profile
. ~/.bash_profile
```

Install ruby 2.4.1

Install qt5

```
sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
```

Install redis

```
brew install redis
```

```
echo 'redis-server --daemonize yes' >> ~/.bash_profile
```

Install postgresql

```
brew install postgresql
```

```
echo 'pg_ctl start -D /home/linuxbrew/.linuxbrew/var/postgres -l logfile' >> ~/.bash_profile
```

Install pdftk

```
sudo apt-get install pdftk
```

Install nodejs

```
brew install nodejs
```

Restart bash

```
. ~/.bash_profile
```


### Install the rails application

```
git clone git@gitlab.com:technovationmx/technovation-rails.git
```

Seed / bootstrap the DB

```
rails db:seed bootstrap bootstrap_search_engine
```

```
rails s -b 0.0.0.0
```

## User type logins:

(all sanitized database users have had their password reset to `secret1234`)

Seeded users:

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
  * username: info@technovationchallenge.org
  * password: <in lastpass/.env>

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
