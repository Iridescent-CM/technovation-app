require './lib/legacy/models/legacy_model'

module Legacy
  class Team < LegacyModel
    enum division: [:ms, :hs, :x]

    has_many :team_requests, -> { where(approved: true) }
    has_many :users, through: :team_requests

    def migrated_description
      description.blank? ? "No description" : description
    end

    def migrated_division
      case division
      when 'ms'
        Division.middle_school
      when 'hs'
        Division.high_school
      when 'x'
        Division.for(users.first)
      else
        raise "division blank -- #{inspect}"
      end
    end

    def migrated_member_ids
      Account.where('email IN (?)', users.pluck(:email)).pluck(:id)
    end
  end
end
