# Technovation Challenge Platform

QA: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa)

Master: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master)

Production: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production)

[![We are using BrowserStack for cross-browser compatibility](https://s3.amazonaws.com/technovation-uploads-production/header-logo.png "BrowserStack")](https://www.browserstack.com/)

We use BrowserStack to [test for cross-browser compatibility](https://www.browserstack.com/) so that we can support a worldwide community of volunteers!

## Rails Docs:
[http://api.rubyonrails.org/v5.1.6](api.rubyonrails.org/v5.1.6)

## Installation and Setup

### Prerequisites

#### macOS

Install homebrew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install asdf, ruby 2.6.4, nodejs <latest-version>

```
brew install asdf

asdf plugin-add ruby
asdf plugin-add nodejs

asdf install ruby 2.6.4
asdf install nodejs <latest-version>
```

Make sure XCode is installed.

Under Xcode preferences locations, make sure there is a version set.


Install qt5

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

Install redis  (follow the post-install instructions)

```
brew install redis
```

Install postgresql (follow the post-install instructions)

```
brew install postgresql
createuser -s postgres
```

Install imagemagick

```
brew install imagemagick
```

Install canvas polyfill requirements for Jest test runner

```
brew install pkg-config cairo libpng jpeg giflib
```

Install pdftk

[https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg)

### Install the rails application

```
git clone git@github.com:Iridescent-CM/technovation-app.git
```

Move the `.env` file that your team should have given you Dropbox access to

```
cd technovation-app
mv <PATH-TO-.ENV-FILE> .
```

Switch to ruby 2.6.4 (this creates the `.tool-versions` file and you won't have to do it again)
Switch to nodejs <latest-version>
```
asdf local ruby 2.6.4
asdf local nodejs <latest-version>
```

Run the rails setup file

```
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

To compile and hot reload assets, run the following in a new terminal window

```
./bin/webpack-dev-server
```

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

* Chapter Ambassador
  * username: ra@ra.com
  * password: ra@ra.com

* Admin
  * username: admin@admin.com
  * password: admin@admin.com

## To turn on/off various user features:

  * Login as the admin
  * Go to "Content & Settings"
  * Toggle what you need on or off


## Tests

Technovation uses RSpec, and you can run the entire test suite just by entering the command `rake`

```
rake
```
