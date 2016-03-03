class WelcomeController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_registered
  def index
    @announcements = Announcement.where(published: true).order(created_at: :desc).limit(5)
  end
end
