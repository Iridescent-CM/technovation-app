class MentorsController < ApplicationController
  def show
    @mentor = MentorAccount.find(params.fetch(:id))
  end
end
