class MentorController < ApplicationController
  before_action :authenticate_user!, except: :index

  User::EXPERTISES.each do |s|
    has_scope s[:sym], type: :boolean, default: false
  end

  def index
    @mentors = apply_scopes(policy_scope(User)).mentor.has_expertise
    if current_user.geocoded?
      @mentors = @mentors.near(current_user, 10000)
    end
  end
end
