require './lib/legacy/models/team'

module Legacy
  class TeamRequest < LegacyModel
    belongs_to :user
    belongs_to :team
  end
end
