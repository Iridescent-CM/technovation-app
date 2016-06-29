class MentorsController < ApplicationController
  def show
    @mentor = Mentor.find(params.fetch(:id))
  end
end
