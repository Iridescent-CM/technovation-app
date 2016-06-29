require "rails_helper"

class FindAMentorTest < Capybara::Rails::TestCase
  def setup
    student = CreateAccount.(student_attributes)

    sign_in(student)
    visit student_dashboard_path
  end

  def test_list_mentors
    mentor = CreateAccount.(mentor_attributes(email: "mentor@mentor.com",
                                              first_name: "Joe",
                                              last_name: "Technovation"))
    click_link "Find a mentor"
    assert page.has_link?("Joe Technovation", href: mentor_path(mentor))
    refute page.has_link?("Basic McGee")
  end

  def test_filter_mentors_by_expertise
    Expertise.create!(name: "Will be assigned")

    mentor = CreateAccount.(mentor_attributes(email: "mentor@mentor.com",
                                              first_name: "Joe",
                                              last_name: "Technovation"))

    Expertise.create!(name: "Wasn't assigned")

    click_link "Find a mentor"

    check "Wasn't assigned"
    click_button "Filter"

    refute page.has_link?("Joe Technovation")

    click_link "Find a mentor"
    check "Will be assigned"
    click_button "Filter"

    assert page.has_link?("Joe Technovation", href: mentor_path(mentor))
  end
end
