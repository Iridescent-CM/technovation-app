module StoreLocation
  def self.call(options)
    location_storage = LocationStorage.for(options)
    location_storage.execute
  end
end
