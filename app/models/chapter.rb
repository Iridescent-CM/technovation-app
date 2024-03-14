class Chapter < ActiveRecord::Base
  include ActiveGeocoded

  has_many :chapter_ambassador_profiles
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation"
end
