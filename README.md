# Technovation Challenge Platform

# User Accounts

## Distinguished by profile types (judge, student, mentor, coach...)

Developers should find/create accounts by their respectively named child classes:

```ruby
AdminAccount.find # ...
CoachAccount.find # ...
JudgeAccount.create # ...
MentorAccount.where # ...
StudentAccount # ...
```

This returns a child instance of `Account` which implies they have the proper `<type>Profile` associated

Developers should ignore `<type>Profile` models, they are deep inner-workings of the system

Wherever the helper `current_<profile_type>` is available, it returns an instance `<profile_type>Account`
