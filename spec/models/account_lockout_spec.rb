# frozen_string_literal: true

require "rails_helper"

RSpec.describe Account, "lockout" do
  let(:account) { FactoryBot.create(:account, password: "secret1234") }

  describe "#locked?" do
    it "returns false when locked_at is blank" do
      expect(account.locked?).to be(false)
    end

    it "returns true when locked within the lockout period" do
      account.update!(failed_attempts: Account::MAX_FAILED_ATTEMPTS, locked_at: 5.minutes.ago)

      expect(account.locked?).to be(true)
    end

    it "clears expired lockouts and returns false" do
      account.update!(failed_attempts: Account::MAX_FAILED_ATTEMPTS, locked_at: 31.minutes.ago)

      expect(account.locked?).to be(false)
      expect(account.reload.failed_attempts).to eq(0)
      expect(account.locked_at).to be_nil
    end
  end

  describe "#register_failed_attempt!" do
    it "increments failed_attempts" do
      expect {
        account.register_failed_attempt!
      }.to change { account.reload.failed_attempts }.by(1)
    end

    it "locks the account when the threshold is reached" do
      account.update!(failed_attempts: Account::MAX_FAILED_ATTEMPTS - 1)

      Timecop.freeze do
        account.register_failed_attempt!

        expect(account.reload.failed_attempts).to eq(Account::MAX_FAILED_ATTEMPTS)
        expect(account.locked_at).to be_within(1.second).of(Time.current)
        expect(account.locked?).to be(true)
      end
    end
  end

  describe "#reset_failed_attempts!" do
    it "clears failed_attempts and locked_at" do
      account.update!(failed_attempts: 3, locked_at: Time.current)

      account.reset_failed_attempts!

      expect(account.reload.failed_attempts).to eq(0)
      expect(account.locked_at).to be_nil
    end

    it "does nothing when already clear" do
      expect {
        account.reset_failed_attempts!
      }.not_to change { account.reload.updated_at }
    end
  end
end
