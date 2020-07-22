require "rails_helper"
require "reset_vulnerable_passwords"

RSpec.describe ResetVulnerablePasswords do
  let(:dates) {
    [
      Time.new(2018, 10, 1),
      Time.new(2018, 11, 13)
    ]
  }

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:admin2) { FactoryBot.create(:admin) }

  let!(:student) {
    FactoryBot.create(
      :student,
      account: FactoryBot.create(
        :account,
        email: "student@example.com",
        password: "student@example.com",
        created_at: dates.sample
      )
    )
  }

  let!(:mentor) {
    FactoryBot.create(
      :mentor,
      account: FactoryBot.create(
        :account,
        email: "mentor@example.com",
        password: "mentor@example.com",
        created_at: dates.sample
      )
    )
  }

  let!(:judge) {
    FactoryBot.create(
      :judge,
      account: FactoryBot.create(
        :account,
        email: "judge@example.com",
        password: "judge@example.com",
        created_at: dates.sample
      )
    )
  }

  let!(:chapter_ambassador) {
    FactoryBot.create(
      :chapter_ambassador,
      account: FactoryBot.create(
        :account,
        email: "chapter_ambassador@example.com",
        password: "chapter_ambassador@example.com",
        created_at: dates.sample
      )
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
        chapter_ambassador.reload.password_digest
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
        chapter_ambassador.reload.auth_token
      }
    end


    it "affects ONLY accounts signed up between Oct 1 2018 and Nov 13, 2018" do
      profiles = [:student, :judge, :mentor, :chapter_ambassador]

      my_dates = [
        Time.new(2018, 9, 30),
        Time.new(2018, 11, 14),
      ]

      profile = FactoryBot.create(
        profiles.sample,
        account: FactoryBot.create(
          :account,
          email: "notme@notme.com",
          password: "notme@notme.com",
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
      profiles = [:student, :judge, :mentor, :chapter_ambassador]

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
      expect {
        ResetVulnerablePasswords.perform!
      }.to not_change {
        admin.reload.password_digest
      }.and not_change {
        admin.reload.auth_token
      }.and not_change {
        admin2.reload.password_digest
      }.and not_change {
        admin2.reload.auth_token
      }
    end

    it "emails a CSV report of the affected users to the admins" do
      ActionMailer::Base.deliveries.clear

      expect {
        ResetVulnerablePasswords.perform!
      }.to change {
        Export.count
      }.from(0).to(1)
      .and change {
        ActionMailer::Base.deliveries.count
      }.from(0).to(2)

      expect(
        ActionMailer::Base.deliveries.flat_map(&:to)
      ).to match_array([admin.email, admin2.email])

      expect(
        ActionMailer::Base.deliveries.map(&:subject).uniq
      ).to eq(["Password Reset CSV Export of Affected Users"])

      ActionMailer::Base.deliveries.each do |mail|
        expect(mail.body.encoded).to match(Export.last.file_url)
      end
    end
  end
end
