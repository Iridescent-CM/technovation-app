module DataProcessors
  class AssignTeamsToRegionalPitchEvent
    def initialize(team_ids:, rpe_id:)
      @team_ids = team_ids
      @rpe = RegionalPitchEvent.find(rpe_id)
    end

    def call
      results = []

      team_ids.each do |team_id|
        team = Team.find_by(id: team_id)

        if team.blank?
          result = "Could not find team with ID: #{team_id}"
        elsif !team.current_season?
          result = "#{team.name} is not a part of the current season"
        elsif team.submission.blank?
          result = "#{team.name} does not have a submission"
        elsif team.events.include?(rpe)
          result = "#{team.name} is already assigned to this event"
        elsif team.events.present?
          result = "#{team.name} is already assigned to another event"
        elsif rpe.divisions.exclude? team.division
          result = "#{team.name} is not in the correct division for this event (Event divisions: #{rpe.divisions.map(&:name).to_sentence}, Team division: #{team.division.name})"
        else
          team.events << rpe

          result = "Assigned #{team.name} to #{rpe.name}"
        end

        results << result
      end

      Result.new(results:)
    end

    private

    Result = Struct.new(:results, keyword_init: true)

    attr_accessor :rpe, :team_ids
  end
end
