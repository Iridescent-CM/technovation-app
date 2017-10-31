require "spec_helper"

if !!defined?(Dotenv)
  KEYS_IN_CIRCLE_PROJECT_SETTINGS = %w{
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    CHECKR_API_KEY
  }

  KEYS_NOT_NEEDED_IN_TESTS = %w{
    WEB_CONCURRENCY
    ACTIVE_JOB_BACKEND
    ADMIN_PASSWORD
    SIDEKIQ_SERVER_LIMIT
    LEGACY_DATABASE_URL
    MEMCACHEDCLOUD_PASSWORD
    MEMCACHEDCLOUD_SERVERS
    MEMCACHEDCLOUD_USERNAME
    FORCE_SSL
    MAIL_ADDRESS
    MAIL_DOMAIN
    MAIL_PASSWORD
    MAIL_PORT
    MAIL_USER
    CSV_SOURCE
    CSV_JUDGE_EMAIL
    CSV_JUDGING_ROUND
    LD_LIBRARY_PATH
  }

  RSpec.describe "Circle CI config" do
    it "is not missing env vars from the ENV file" do
      env = Dotenv.load

      circle_src = File.read("./circle.yml")
      circle_env = YAML.load(circle_src)["machine"]["environment"]

      keys_needed =
        env.keys - KEYS_IN_CIRCLE_PROJECT_SETTINGS - KEYS_NOT_NEEDED_IN_TESTS

      combined = keys_needed | circle_env.keys

      missing_keys = combined - circle_env.keys

      expect(missing_keys).to be_empty, "MISSING KEYS: #{missing_keys}"
    end
  end
end
