class MentorController < ApplicationController

  User::EXPERTISES.each do |s|
    has_scope s[:sym], type: :boolean, default: false
  end

  def index
    @mentors = apply_scopes(User).mentor.has_expertise
  end
end
