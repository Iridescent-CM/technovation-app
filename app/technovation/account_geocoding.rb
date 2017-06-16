class AccountGeocoding
  private
  attr_reader :account

  public
  def initialize(account)
    @account = account
  end

  def self.perform(account)
    new(account).perform
  end

  def perform
    Casting.delegating(account => GeocodingUpdater) do
      account.apply_geocoding_changes
    end

    self
  end

  def perform_with_save
    perform
    with_save
  end

  def with_save
    account.save
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
