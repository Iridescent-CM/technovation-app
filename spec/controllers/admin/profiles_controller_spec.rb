require "rails_helper"

RSpec.describe Admin::ProfilesController do
  before do
    admin = FactoryGirl.create(:admin)
    sign_in(admin)
  end

  it "sends a message to student's team to reconsider division on dob change" do
    student = FactoryGirl.create(
      :student,
      email: "student@testing.com",
      date_of_birth: 13.years.ago
    )
    team = FactoryGirl.create(:team, members_count: 0)
    TeamRosterManaging.add(team, student)

    expect(team.division_name).to eq("junior")

    patch :update, params: {
      id: student.id,
      student_profile: {
        account_attributes: {
          id: student.account_id,
          date_of_birth: 15.years.ago,
        },
      }
    }

    expect(team.reload.division_name).to eq("senior")
  end

  %w{student mentor judge regional_ambassador}.each do |scope|
    it "updates #{scope} newsletters with a change to the email address" do
      profile = FactoryGirl.create(scope, email: "old@oldtime.com")

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.id,
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            email: "new@email.com",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(profile.account_id, "old@oldtime.com", "#{scope.upcase}_LIST_ID")
    end

    it "updates newsletters with a change to the address" do
      profile = FactoryGirl.create(scope)

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.id,
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            city: "Los Angeles",
            state_province: "CA",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(profile.account_id, profile.account.email, "#{scope.upcase}_LIST_ID")
    end

    it "updates #{scope} newsletters with changes to first name" do
      profile = FactoryGirl.create(scope)

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.id,
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            first_name: "someone cool",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(profile.account_id, profile.account.email, "#{scope.upcase}_LIST_ID")
    end

    it "updates #{scope} newsletters with changes to last name" do
      profile = FactoryGirl.create(scope)

      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

      patch :update, params: {
        id: profile.id,
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            last_name: "someone really cool",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(profile.account_id, profile.account.email, "#{scope.upcase}_LIST_ID")
    end
  end
end
