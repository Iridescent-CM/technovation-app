class AvailabilitySlot < ActiveRecord::Base
  has_many :community_connection_availability_slots
  has_many :community_connections, through: :community_connection_availability_slots
end
