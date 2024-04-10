class Chapter < ActiveRecord::Base
  include ActiveGeocoded

  has_many :chapter_ambassador_profiles
  belongs_to :primary_chapter_ambassador_profile,
             class_name: "ChapterAmbassadorProfile",
             foreign_key: "primary_chapter_ambassador_profile_id",
             optional: true
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation"
end
