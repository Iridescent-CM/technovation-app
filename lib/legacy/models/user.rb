require './lib/legacy/models/team_request'

module Legacy
  class User < LegacyModel
    enum role: [:student, :mentor, :coach, :judge]

    has_many :team_requests, -> { where(approved: true) }
    has_many :teams, through: :team_requests

    def parent_name
      [parent_first_name, parent_last_name].join(" ")
    end

    def is_in_secondary_school?
      grade.blank? ? false : grade.to_i >= 9
    end

    def migrated_home_state
      home_state.blank? ? "N/A" : home_state
    end
  end
end
