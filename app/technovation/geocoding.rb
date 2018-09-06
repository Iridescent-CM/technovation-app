class Geocoding
  private
  attr_reader :model

  public
  def initialize(model)
    @model = model
  end

  def self.perform(model)
    new(model).perform
  end

  def perform
    Casting.delegating(model => GeocodingUpdater) do
      model.apply_geocoding_changes
    end

    self
  end

  def perform_with_save
    perform
    with_save
  end

  def with_save
    model.save
    self
  end

  private
  module GeocodingUpdater
    def apply_geocoding_changes
      geocode if !valid_coordinates? || (
                   (saved_change_to_city? || city_changed?) &&
                     !city_was.blank?
                 )

      reverse_geocode if saved_change_to_latitude? ||
                           saved_change_to_longitude? ||
                             latitude_changed? ||
                               longitude_changed?
    end
  end
end
