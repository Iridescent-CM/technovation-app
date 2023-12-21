class Geocoding
  private

  attr_reader :model, :controller

  public

  def initialize(model, controller)
    @model = model
    @controller = controller
  end

  def self.perform(model, controller = nil)
    new(model, controller).perform
  end

  def perform
    Casting.delegating(model => GeocodingUpdater) do
      model.apply_geocoding_changes(controller)
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
    def apply_geocoding_changes(controller)
      Rails.logger.warn("Geocoding #{self.class} id:#{id} with invalid address") if !valid_address?

      geocode if !valid_coordinates? || detect_location_changes?

      if controller
        StoreLocation.call(coordinates: coordinates,
          account: self,
          context: controller)
      end
    end
  end
end
