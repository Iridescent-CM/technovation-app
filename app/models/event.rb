class Event < ActiveRecord::Base
  has_many :teams
  belongs_to :region

  scope :display_order, -> {
    order("name!='Virtual Judging', name")
  }

  scope :open_for_signup, -> {
    display_order.where("extract(year from whentooccur) = ?", Setting.year)
  }

  scope :nonconflicting_events, ->(conflict_regions) {
    open_for_signup.where("region_id not in (?) OR region_id=-1 OR region_id IS NULL", (conflict_regions << -1))
  }

end
