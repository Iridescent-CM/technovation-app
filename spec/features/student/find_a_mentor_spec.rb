require "rails_helper"

RSpec.xfeature "Students invite mentors to join their team" do
  before { SeasonToggles.team_building_enabled = "yes" }

  let(:student) { FactoryBot.create(:student, :geocoded, :on_team) }
  let!(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }

  before do
    sign_in(student)
    visit student_team_path(student.team)
    click_link "Search for a mentor to invite"
  end

  scenario "only see current mentors" do
    past = FactoryBot.create(
      :mentor,
      :geocoded,
      first_name: "Not me"
    )

    past.account.update(
      seasons: [Season.current.year - 1]
    )

    visit new_student_mentor_search_path

    expect(page).not_to have_content("Not me")
  end

  scenario "Invite an available mentor" do
    click_link "View more details"
    click_button "Ask #{mentor.first_name}"
    expect(page).to have_content("Your team invite was sent!")
  end

  scenario "Find a mentor on your team" do
    TeamRosterManaging.add(student.team, mentor)
    click_link "View more details"
    expect(page).to have_content("#{mentor.first_name} is a mentor on your team.")
  end

  scenario "Find a mentor you already invited" do
    student.team.mentor_invites.create!(
      invitee_email: mentor.email,
      inviter: student
    )
    click_link "View more details"
    expect(page).to have_content("Your team has invited #{mentor.first_name}")
  end

  scenario "Find a mentor who already requested" do
    mentor.join_requests.create!(team: student.team)
    click_link "View more details"
    expect(page).to have_content(
      "#{mentor.first_name} has asked to mentor your team"
    )
  end
end
