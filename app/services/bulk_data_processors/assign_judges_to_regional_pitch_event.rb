module BulkDataProcessors
  class AssignJudgesToRegionalPitchEvent
    def initialize(regional_pitch_event:, judge_ids:)
      @regional_pitch_event = regional_pitch_event
      @judge_ids = judge_ids
    end

    def call
      results = []

      judge_ids.each do |judge_id|
        judge_profile = JudgeProfile.find_by(id: judge_id)

        if judge_profile.blank?
          result = "Could not find judge with ID: #{judge_id}"
        elsif !judge_profile.current_season?
          result = "#{judge_profile.name} is not a part of the current season"
        elsif judge_profile.events.include?(regional_pitch_event)
          result = "#{judge_profile.name} has already been assigned to this event"
        else
          judge_profile.events << regional_pitch_event

          result = "Assigned #{judge_profile.name} to #{regional_pitch_event.name}"

        end

        results << result
      end

      Result.new(results:)
    end

    private

    Result = Struct.new(:results, keyword_init: true)

    attr_accessor :regional_pitch_event, :judge_ids
  end
end
