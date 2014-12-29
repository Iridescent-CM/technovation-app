class WelcomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @announcements = Announcement.where(published: true).order(created_at: :desc).limit(5)
  end
end
