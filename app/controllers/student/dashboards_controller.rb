module Student
  class DashboardsController < StudentController
    def show
      @regional_events = RegionalPitchEvent.available_to(current_team.submission)

      if current_team.submission.present? and ENV["ENABLE_TEAM_SCORES"]
        @scores = current_team.submission.submission_scores.complete.quarterfinals
        if @scores.any?
          @ideation_average = category_average(:ideation)
          @technical_average = category_average(:technical)
          @entrepreneurship_average = category_average(:entrepreneurship)
          @pitch_average = category_average(:pitch)
          @overall_impression_average = category_average(:overall_impression)
          @best_category = best_category
        end
      end
    end

    private
    def category_average(category)
      sum = @scores.inject(0.0) do |acc, score|
        if score.official?
          acc += score.public_send("#{category}_total")
        end
      end
      (sum / @scores.count.to_f).round(2)
    end

    def best_category
      adjusted_scores = {
        "Ideation": (@ideation_average * 25/15),
        "Technical": @technical_average,
        "Entrepreneurship":  @entrepreneurship_average,
        "Pitch": @pitch_average,
        "Overall Impression": (@overall_impression_average * 20/25),
      }

      adjusted_scores.max_by { |_,v| v }[0]
    end
  end
end
