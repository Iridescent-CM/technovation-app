# frozen_string_literal: true

require "rails_helper"

RSpec.describe Account, "admin lifecycle" do
  describe "#password_expired?" do
    it "is false for non-admin accounts even with an old password_changed_at" do
      account = FactoryBot.create(:account, password_changed_at: 120.days.ago)

      expect(account.password_expired?).to be(false)
    end

    it "is false when password_changed_at is blank" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: nil)

      expect(admin.account.password_expired?).to be(false)
    end

    it "is false when the password was changed within the max age" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: 30.days.ago)

      expect(admin.account.password_expired?).to be(false)
    end

    it "is true when an admin password is older than the max age" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: 91.days.ago)

      expect(admin.account.password_expired?).to be(true)
    end
  end

  describe "password_changed_at stamp" do
    it "sets password_changed_at when the password digest changes" do
      account = FactoryBot.create(:account, password_changed_at: 10.days.ago)

      Timecop.freeze do
        account.update!(
          skip_existing_password: true,
          password: PasswordHelpers::VALID_PASSWORD,
          password_confirmation: PasswordHelpers::VALID_PASSWORD
        )

        expect(account.reload.password_changed_at).to be_within(1.second).of(Time.current)
      end
    end
  end

  describe ".inactive_admins_for_deactivation" do
    it "includes admins whose last login is older than the inactivity threshold" do
      inactive = FactoryBot.create(:admin)
      inactive.account.update_columns(last_logged_in_at: 91.days.ago, deactivated_at: nil)

      active = FactoryBot.create(:admin)
      active.account.update_columns(last_logged_in_at: 1.day.ago, deactivated_at: nil)

      expect(Account.inactive_admins_for_deactivation).to include(inactive.account)
      expect(Account.inactive_admins_for_deactivation).not_to include(active.account)
    end

    it "uses created_at when last_logged_in_at is nil" do
      never_logged_in = FactoryBot.create(:admin)
      never_logged_in.account.update_columns(
        last_logged_in_at: nil,
        created_at: 91.days.ago,
        deactivated_at: nil
      )

      expect(Account.inactive_admins_for_deactivation).to include(never_logged_in.account)
    end

    it "excludes already deactivated admins" do
      deactivated = FactoryBot.create(:admin)
      deactivated.account.update_columns(
        last_logged_in_at: 91.days.ago,
        deactivated_at: 1.day.ago
      )

      expect(Account.inactive_admins_for_deactivation).not_to include(deactivated.account)
    end

    it "excludes non-admin accounts" do
      student = FactoryBot.create(:student)
      student.account.update_columns(last_logged_in_at: 91.days.ago)

      expect(Account.inactive_admins_for_deactivation).not_to include(student.account)
    end
  end

  describe "#deactivated?" do
    it "is true when deactivated_at is present" do
      account = FactoryBot.create(:account, deactivated_at: Time.current)

      expect(account.deactivated?).to be(true)
    end

    it "is false when deactivated_at is blank" do
      account = FactoryBot.create(:account)

      expect(account.deactivated?).to be(false)
    end
  end

  describe "admin password rules when expired" do
    it "requires a 20-character complex password for expired admins" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: 91.days.ago)

      admin.account.assign_attributes(
        skip_existing_password: true,
        password: "Short1"
      )

      expect(admin.account).not_to be_valid
      expect(admin.account.errors[:password]).to be_present
    end
  end
end
