class Event < ActiveRecord::Base
  has_many :teams
  belongs_to :region

  scope :open_for_signup, -> {
    order("name!='Virtual Judging', name")
  }
  scope :nonconflicting_events, ->(conflict_regions) {
    open_for_signup.where("region_id not in (?) OR region_id=-1 OR region_id IS NULL", (conflict_regions << -1))
  }

end
