# Technovation Challenge Platform

QA: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa)

Master: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master)

Production: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production)

## Installation and Setup

### Prerequisites

#### macOS

Install homebrew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install ruby 2.4.1

```
brew install rbenv
rbenv install 2.4.1
```

Install qt5

Make sure that you have xcode installed.

Under Xcode preferences locations, make sure there is a version set.

```
brew install qt@5.5
echo 'export PATH="$(brew --prefix qt@5.5)/bin:$PATH"' >> ~/.bashrc
```

After running this command:

```
which qmake
```

...you should get the following output:
```
/usr/local/bin/qmake
```

Install redis

```
brew install redis
```

Install postgresql

```
brew install postgresql
```

Install pdftk

[https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg)

Install nodejs

```
brew install nodejs
```


### Install the rails application

```
git clone git@github.com:Iridescent-CM/technovation-app.git
```

Run bin/setup

```
cd technovation-app
./bin/setup
```

Ensure the test suite can run without errors:

```
rake
```

Run the local server

```
rails s
```

Navigate to [http://localhost:3000](http://localhost:3000)


## User type logins:

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
  * password: <check in lastpass/.env>

## To turn on/off various user features:

  * Login as the admin
  * Go to "Season Schedule Settings"
  * Toggle what you need on or off


## Tests

Technovation uses RSpec, and you can run the entire test suite just by entering the command `rake`

```
rake
```
