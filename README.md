# Technovation Challenge Platform

## Installation and Setup

### Prerequisites

You **must** install `qt5` for the gem `capybara-webkit` to install:

https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit

You **must** install `elasticsearch`

```
brew update
brew install elasticsearch
brew services start elasticsearch
```

You **must** install `postgresql`

```
brew update
brew install postgresql
```

You **must** install `redis server`

```
brew update
brew install redis
```

### Setup

Set your Ruby version with your favorite ruby version management tool **(RVM, rbenv, chruby, etc)** to:

`Use Ruby Version: 2.3.1`

Request sensitive keys from your teammates for the `.env` file.

```
git clone git@github.com:Iridescent-CM/technovation-app.git
cd technovation-app
*** GET THE SENSITIVE INFO FOR .env FILE ***
./bin/setup
```

## Drop / recreate / re-seed / re-bootstrap  database

```
rake db:drop db:create db:migrate && rake db:seed bootstrap
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
rake db:seed 
# Seeds with a student, a couple of mentors, and an admin for manual testing
```

```
rake bootstrap
# Adds the Technovation expertises for mentors to choose for their profile
# Adds the Technovation admin account
```
