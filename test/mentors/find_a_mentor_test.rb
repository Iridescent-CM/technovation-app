require "rails_helper"

class FindAMentorTest < Capybara::Rails::TestCase
  def test_list_mentors
    mentor = CreateAccount.(mentor_attributes(email: "mentor@mentor.com",
                                              first_name: "Joe",
                                              last_name: "Technovation"))
    student = CreateAccount.(student_attributes)

    sign_in(student)
    visit student_dashboard_path
    click_link "Find a mentor"

    assert page.has_link?("Joe Technovation", href: mentor_path(mentor))
    refute page.has_link?("Basic McGee")
  end
end
