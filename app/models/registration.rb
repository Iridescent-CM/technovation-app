class Registration < ActiveRecord::Base
  belongs_to :season
  belongs_to :registerable, polymorphic: true
end
