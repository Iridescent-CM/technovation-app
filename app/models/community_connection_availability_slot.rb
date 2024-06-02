class CommunityConnectionAvailabilitySlot < ActiveRecord::Base
  belongs_to :community_connection
  belongs_to :availability_slot
end
