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
      if latitude.blank? or (not city_was.blank? and saved_change_to_city?)
        geocode
      end

      if saved_change_to_latitude? or saved_change_to_longitude?
        reverse_geocode
      end

      self.location_confirmed = (not city.blank? and not country.blank?)
    end
  end
end
