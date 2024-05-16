require "spec_helper"

if !!defined?(Dotenv)
  KEYS_IN_CIRCLE_PROJECT_SETTINGS = %w[
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    CHECKR_API_KEY
  ]

  KEYS_NOT_NEEDED_IN_TESTS = %w[
    ACTIVE_JOB_BACKEND
    CONVERT_MENTORS
    CSV_JUDGE_EMAIL
    CSV_JUDGING_ROUND
    CSV_SOURCE
    DEV_SPOOF_IP
    DO_NOT_FILL_CERTIFICATES
    ENABLE_HEAP
    ENABLE_MAILCHIMP
    ENABLE_MENTOR_MODE_FOR_ALL_JUDGES
    ENABLE_MENTOR_MODE_ONLY_FOR_JUDGES_WITH_EXISTING_MENTOR_PROFILE
    ENABLE_JUDGE_MODE_FOR_ALL_MENTORS
    FORCE_SSL
    GOOGLE_ANALYTICS_ID
    HEAP_APP_ID
    JAVASCRIPT_DRIVER
    JUDGE_TRAINING_READY
    LD_LIBRARY_PATH
    LEGACY_DATABASE_URL
    MAIL_ADDRESS
    MAIL_PASSWORD
    MAIL_PORT
    MAIL_USER
    MANAGE_EVENTS
    MEMCACHEDCLOUD_PASSWORD
    MEMCACHEDCLOUD_SERVERS
    MEMCACHEDCLOUD_USERNAME
    MENTOR_TRAINING_DOC_URL
    NODE_ENV
    OPEN_PAGE_ON_FAILURE
    OPEN_SCREENSHOT_ON_FAILURE
    RSPEC_FAIL_FAST
    SIDEKIQ_SERVER_LIMIT
    WEB_CONCURRENCY
  ]

  RSpec.describe "Circle CI config" do
    it "is not missing env vars from the ENV file" do
      env = Dotenv.load

      circle_src = File.read("./circle.yml")
      circle_env = YAML.load(circle_src)["jobs"]["build"]["docker"][0]["environment"]

      keys_needed =
        env.keys - KEYS_IN_CIRCLE_PROJECT_SETTINGS - KEYS_NOT_NEEDED_IN_TESTS

      combined = keys_needed | circle_env.keys

      missing_keys = combined - circle_env.keys

      expect(missing_keys).to be_empty, "MISSING KEYS: #{missing_keys}"
    end
  end
end
