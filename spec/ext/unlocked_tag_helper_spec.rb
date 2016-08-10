require "rails_helper"

RSpec.describe UnlockedTagHelper do
  include UnlockedTagHelper
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  let(:user) { double(:user, type_name: "student").as_null_object }

  it "links to unlocked actions" do
    link_html = unlocked_link_to(user, "Link text", root_path, class: "some-css")
    expect(link_html).to eq(link_to "Link text", root_path, class: "some-css")
  end

  it "restricts against locked actions" do
    allow(user).to receive(:parental_consent_signed?) { false }
    link_html = unlocked_link_to(user, "Link text", new_student_team_path)
    expect(link_html).to be_blank
  end

  it "links to unlocked actions" do
    html = unlocked_content_tag(user, root_path, :li, "content", class: "some-css")
    expect(html).to eq(content_tag :li, "content", class: "some-css")
  end

  it "restricts against locked actions" do
    allow(user).to receive(:parental_consent_signed?) { false }
    html = unlocked_content_tag(user, new_student_team_path, :li, "content", class: "some-css")
    expect(html).to be_blank
  end
end
