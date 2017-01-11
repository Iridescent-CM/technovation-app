class RegionalPitchEvent < ActiveRecord::Base
  has_and_belongs_to_many :divisions

  validates :name, :starts_at, :ends_at, :division_ids, :city, :venue_address,
    presence: true
end
