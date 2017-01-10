class RegionalPitchEvent < ActiveRecord::Base
  validates :starts_at, :ends_at,
    presence: true
end
