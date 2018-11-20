require "rails_helper"
require "reset_vulnerable_passwords"

RSpec.describe ResetVulnerablePasswords do
  let(:dates) {
    [
      Time.new(2018, 10, 1),
      Time.new(2018, 11, 13)
    ]
  }

  let!(:student) {
    FactoryBot.create(
      :student,
      account: FactoryBot.create(:account, created_at: dates.sample)
    )
  }

  let!(:mentor) {
    FactoryBot.create(
      :mentor,
      account: FactoryBot.create(:account, created_at: dates.sample)
    )
  }

  let!(:judge) {
    FactoryBot.create(
      :judge,
      account: FactoryBot.create(:account, created_at: dates.sample)
    )
  }

  let!(:ra) {
    FactoryBot.create(
      :ra,
      account: FactoryBot.create(:account, created_at: dates.sample)
    )
  }

  describe ".perform!" do
    it "resets passwords to a secure string" do
      expect {
        ResetVulnerablePasswords.perform!
      }.to change {
        student.reload.password_digest
      }.and change {
        mentor.reload.password_digest
      }.and change {
        judge.reload.password_digest
      }.and change {
        ra.reload.password_digest
      }
    end

    it "regenerates auth tokens" do
      expect {
        ResetVulnerablePasswords.perform!
      }.to change {
        student.reload.auth_token
      }.and change {
        mentor.reload.auth_token
      }.and change {
        judge.reload.auth_token
      }.and change {
        ra.reload.auth_token
      }
    end


    it "affects ONLY accounts signed up between Oct 1 2018 and Nov 13, 2018" do
      profiles = [:student, :judge, :mentor, :ra]

      my_dates = [
        Time.new(2018, 9, 30),
        Time.new(2018, 11, 14),
      ]

      profile = FactoryBot.create(
        profiles.sample,
        account: FactoryBot.create(
          :account,
          created_at: my_dates.sample
        )
      )

      expect {
        ResetVulnerablePasswords.perform!
      }.to not_change {
        profile.reload.password_digest
      }.and not_change {
        profile.reload.auth_token
      }
    end

    it "affects ONLY the timeframed accounts which have their email as their password" do
      profiles = [:student, :judge, :mentor, :ra]

      profile = FactoryBot.create(
        profiles.sample,
        account: FactoryBot.create(
          :account,
          password: "somethingelsenotemail!!",
          created_at: dates.sample,
        )
      )

      expect {
        ResetVulnerablePasswords.perform!
      }.to not_change {
        profile.reload.password_digest
      }.and not_change {
        profile.reload.auth_token
      }
    end

    it "does not affect admins" do
      account = FactoryBot.create(
        :admin,
        account: FactoryBot.create(:account, created_at: dates.sample)
      )

      expect {
        ResetVulnerablePasswords.perform!
      }.to not_change {
        account.reload.password_digest
      }.and not_change {
        account.reload.auth_token
      }
    end
  end
end