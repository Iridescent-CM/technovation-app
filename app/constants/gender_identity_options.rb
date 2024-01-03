# If these change, you will need to update various TC dataclips on Heroku.
# Alternatively, these could be moved to a table in the database and the
# the dataclips could just be updated once to relfect the new table.
GENDER_IDENTITY_OPTIONS = %w[
  Female
  Male
  Non-binary
  Prefer\ not\ to\ say
]
