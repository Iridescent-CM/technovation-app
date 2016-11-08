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

### Setup

Set your Ruby version with your favorite ruby version management tool to:

`Ruby Version: 2.3.1`

Request sensitive keys from your teammates for the `.env` file.

```
git clone git@github.com:Iridescent-CM/technovation-app.git
cd technovation-app
*** GET THE SENSITIVE INFO FOR .env FILE ***
./bin/setup
```

## Development server

```
$ rails server
```

## Tests

TechnovationApp uses RSpec

```
$ rake
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

### SearchMentors

* Call with a `SearchFilter` instance
* Filter options:
  * :expertise_ids
    * can be a single ID, or a collection of IDs

```ruby
search_filter = SearchFilter.new({ expertise_ids: 1 })
SearchMentors.(search_filter)

search_filter = SearchFilter.new({ expertise_ids: [1, 2] })
SearchMentors.(search_filter)

search_filter = SearchFilter.new({ expertise_ids: ["1", "2"] })
SearchMentors.(search_filter)
```

## Controllers

Wherever the helper method `current_{profile_name}` is available, it returns an instance of `{ProfileName}Account`.
