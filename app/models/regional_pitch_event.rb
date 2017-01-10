class RegionalPitchEvent < ActiveRecord::Base
  belongs_to :division

  validates :starts_at, :ends_at, :division_id, :city, :venue_address,
    presence: true

  delegate :name, to: :division, prefix: true, allow_nil: true
end
