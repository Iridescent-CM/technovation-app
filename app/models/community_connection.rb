class CommunityConnection < ActiveRecord::Base
  belongs_to :chapter_ambassador_profile

  has_many :community_connection_availability_slots
  has_many :availability_slots, through: :community_connection_availability_slots
end
