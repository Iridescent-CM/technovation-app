class Announcement < ActiveRecord::Base

  enum role: [:any, :student, :mentor, :coach, :judge]

end
