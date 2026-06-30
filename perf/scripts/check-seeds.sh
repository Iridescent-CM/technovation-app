#!/usr/bin/env bash
# Confirm seeded perf accounts exist and accept password == email before auth/Lighthouse runs.
# Usage: ./perf/scripts/check-seeds.sh
set -euo pipefail

result="$(bundle exec rails runner '
  emails = %w[
    student@student.com
    mentor@mentor.com
    judge@judge.com
    chapter-ambassador@chapter-ambassador.com
    admin@admin.com
  ]
  emails.each do |email|
    account = Account.find_by(email: email)
    if account.nil?
      puts "missing:" + email
    elsif !account.authenticate(email)
      puts "bad_password:" + email
    end
  end
')"

if [ -n "$result" ]; then
  echo "check-seeds: perf accounts not ready:" >&2
  echo "$result" | while IFS= read -r line; do
    case "$line" in
      missing:*)
        echo "  - ${line#missing:} (not in DB)" >&2
        ;;
      bad_password:*)
        echo "  - ${line#bad_password:} (exists but password != email)" >&2
        ;;
    esac
  done
  echo >&2
  echo "Fix (pick one):" >&2
  echo "  bundle exec rails db:seed    # if accounts missing" >&2
  echo "  # reset a single account password to match email (example mentor):" >&2
  echo "  bundle exec rails runner \"a=Account.find_by!(email: '"'"'mentor@mentor.com'"'"'); a.skip_existing_password=true; a.update!(password: '"'"'mentor@mentor.com'"'"')\"" >&2
  echo "  ./perf/scripts/check-seeds.sh" >&2
  exit 1
fi

echo "check-seeds: ok — all 5 perf accounts present with password == email"
