# Technovation Challenge Platform

## Installation and Setup

### Prerequisites OS X 10.11+

You must install `qt5` for the gem `capybara-webkit` to install:

```
brew update
brew install qt5
```

### Prerequisites OS X 10.9, 10.10

You must install `qt` for the gem `capybara-webkit` to install:

```
brew update
brew install qt
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
rake bootstrap:technovation
# Adds the Technovation expertises for mentors to choose for their profile
# Adds the Technovation admin account
```

## User Accounts

### Distinguished by profile types (judge, student, mentor...)

Developers should interact with user accounts by their respectively named child classes:

```ruby
AdminAccount.find # ...
JudgeAccount.create # ...
MentorAccount.where # ...
StudentAccount # ...
```

These models return child instances of `Account` which hold their proper `{Name}Profile`.

Do not directly access the `{Name}Profile` and `Account` models, they are deep implementation details.

### {ProfileName}Account

* Behavior specific to its associated profile type
* Validates its associated profile type

### Account

* **Do not access directly**
* Authentication attributes (email, password, auth_token)
* Basic attributes shared by all accounts (name, address, date of birth, etc)
* Validations for these attributes

### {Name}Profile

* **Do not access directly**
* Attributes and validations specific to each type of profile
  * (e.g., `StudentProfile` has `#parent_guardian_email` but other `{Name}Profile`s do not)
* Authorization in controllers is inferred by the association of these profiles to the `Account` with the cookie'd auth_token

## Rails.root/app/technovation/

### FindAccount

* Use this module as the API for authenticating based on auth_token in cookies

```ruby
FindAccount.current(:student, cookies)
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

### CreateScoringRubric

* Used in seeds, ignore for now

## Controllers

Wherever the helper method `current_{profile_name}` is available, it returns an instance of `{ProfileName}Account`.
