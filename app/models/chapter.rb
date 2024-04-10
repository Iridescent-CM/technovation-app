class Chapter < ActiveRecord::Base
  include ActiveGeocoded

  has_many :chapter_ambassador_profiles
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation"

  def has_primary_contact?
    chapter_ambassador_profiles.where(is_primary_contact: true).exists?
  end

end
