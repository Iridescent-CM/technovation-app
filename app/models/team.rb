class Team < ActiveRecord::Base
  belongs_to :season
  belongs_to :division
  belongs_to :region
end
