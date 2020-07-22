require "rails_helper"

RSpec.feature "Chapter ambassadors viewing regional activity" do
  scenario "viewing the activity table" do
    mentor = FactoryBot.create(:mentor)
    team = FactoryBot.create(:team) # 1 student by default
    student = team.students.last

    TeamRosterManaging.add(team, mentor)
    TeamRosterManaging.remove(team, student)

    chapter_ambassador = FactoryBot.create(:ambassador, :geocoded, :approved)
    sign_in(chapter_ambassador)

    click_link "Activity"

    within("table.datagrid") do
      expect(page).to have_content(team.name, count: 5)
      # 1. created
      # 2. registered season
      # 3. mentor joined
      # 4. student joined
      # 5. student left

      expect(page).to have_content("was created", count: 1)

      expect(page).to have_content(
        "registered for the #{Season.current.year} season", count: 3
      )
      # 1. team
      # 2. mentor
      # 3. student

      expect(page).to have_content(mentor.name, count: 3)
      # 1. signed up
      # 2. register season
      # 3. joined team

      expect(page).to have_content("joined a team", count: 2)
      # 1. mentor
      # 2. student

      expect(page).to have_content(student.name, count: 4)
      # 1. signed up
      # 2. register season
      # 3. joined team
      # 4. left team

      expect(page).to have_content("left a team", count: 1)
    end
  end
end
