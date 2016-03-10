class WelcomeController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_registered
  def index
    roles = [Announcement.roles[current_user.role], Announcement.roles['any']]
    if current_user.judging?
      roles.push(Announcement.roles['judge'])
    end
    @announcements = Announcement.where(published: true, role: roles).order(created_at: :desc).limit(5)
  end
end
