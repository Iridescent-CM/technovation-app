class MentorController < ApplicationController
  before_action :authenticate_user!, except: :index

  User::EXPERTISES.each do |s|
    has_scope s[:sym], type: :boolean, default: false
  end

  def index
    @mentors = apply_scopes(User).mentor.has_expertise
  end
end
