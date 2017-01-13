class RegionalPitchEvent < ActiveRecord::Base
  belongs_to :regional_ambassador_profile

  has_and_belongs_to_many :divisions

  validates :name, :starts_at, :ends_at, :division_ids, :city, :venue_address,
    presence: true

  delegate :state_province, :country, :timezone,
    to: :regional_ambassador_profile,
    prefix: false

  def division_names
    divisions.flat_map(&:name).to_sentence
  end

  def date_time
    [starts_at.in_time_zone(timezone).strftime("%a %b %e, %H:%M"),
     "-",
     ends_at.in_time_zone(timezone).strftime("%H:%M"),
     regional_ambassador_profile.timezone].join(' ')
  end
end
