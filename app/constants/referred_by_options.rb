# If these change, you will need to update various TC dataclips on Heroku.
# Alternatively, these could be moved to a table in the database and the
# the dataclips could just be updated once to relfect the new table.
REFERRED_BY_OPTIONS = {
  "Friend" => 0,
  "Colleague" => 1,
  "Article" => 2,
  "Internet" => 3,
  "Social media" => 4,
  "Print" => 5,
  "Web search" => 6,
  "Teacher" => 7,
  "Parent/family" => 8,
  "Company email" => 9,
  # 10 (Made With Code) was deleted!
  "Other" => 11
}
