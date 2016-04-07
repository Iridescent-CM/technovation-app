class Category < ActiveRecord::Base
  scope :of_season, -> (year) { where(year: year) }
end
