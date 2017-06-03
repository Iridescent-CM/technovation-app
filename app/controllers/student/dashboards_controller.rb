module Student
  class DashboardsController < StudentController
    def show
      @regional_events = RegionalPitchEvent.available_to(current_team.submission)

      if current_team.submission.present? and ENV["ENABLE_TEAM_SCORES"]
        @quarterfinals_scores = current_team.submission.submission_scores.complete.quarterfinals

        if @quarterfinals_scores.any?
          @qf_ideation_average = category_average(:ideation, :quarterfinals)
          @qf_technical_average = category_average(:technical, :quarterfinals)
          @qf_entrepreneurship_average = category_average(:entrepreneurship, :quarterfinals)
          @qf_pitch_average = category_average(:pitch, :quarterfinals)
          @qf_overall_impression_average = category_average(:overall_impression, :quarterfinals)
          @qf_best_category = best_category(:quarterfinals)
          @unofficial_scores = unofficial_scores?
        end

        if current_team.submission.contest_rank == "semifinalist"
          @all_scores = current_team.submission.submission_scores.complete
          @semifinals_scores = current_team.submission.submission_scores.complete.semifinals

          @sf_ideation_average = category_average(:ideation, :semifinals)
          @sf_technical_average = category_average(:technical, :semifinals)
          @sf_entrepreneurship_average = category_average(:entrepreneurship, :semifinals)
          @sf_pitch_average = category_average(:pitch, :semifinals)
          @sf_overall_impression_average = category_average(:overall_impression, :semifinals)
          @sf_best_category = best_category(:semifinals)
        end

      end
    end

    private

    def category_average(category, round)
      if round == :semifinals
        scores = @semifinals_scores
      else
        scores = @quarterfinals_scores
      end
      sum = scores.inject(0.0) do |acc, score|
        if score.official?
          acc += score.public_send("#{category}_total")
        end
      end
      (sum / scores.count.to_f).round(2)
    end

    def unofficial_scores?
      @quarterfinals_scores.each do |score|
        if !score.official?
          return true
          break
        else
          return false
        end
      end
    end

    def best_category(round)
      if round == :semifinals
        adjusted_scores = {
          "Ideation": (@sf_ideation_average * 25/15),
          "Technical": @sf_technical_average,
          "Entrepreneurship":  @sf_entrepreneurship_average,
          "Pitch": @sf_pitch_average,
          "Overall Impression": (@sf_overall_impression_average * 20/25),
        }
      else
        adjusted_scores = {
          "Ideation": (@qf_ideation_average * 25/15),
          "Technical": @qf_technical_average,
          "Entrepreneurship":  @qf_entrepreneurship_average,
          "Pitch": @qf_pitch_average,
          "Overall Impression": (@qf_overall_impression_average * 20/25),
        }
      end
      adjusted_scores.max_by { |_,v| v }[0]
    end

  end
end
