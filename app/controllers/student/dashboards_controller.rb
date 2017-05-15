module Student
  class DashboardsController < StudentController

    def show
      @regional_events = RegionalPitchEvent.available_to(current_team.submission)
      @scores = current_team.submission.submission_scores.quarterfinals

      @ideation_average = ideation_average
      @technical_average = technical_average
      @entrepreneurship_average = entrepreneurship_average
      @pitch_average = pitch_average
      @overall_impression_average = overall_impression_average
      @best_category = best_category
    end

    def ideation_average
      sum = 0
      @scores.each do |score|
        sum += score.technical_total
      end
      return sum/@scores.count
    end

    def technical_average
      sum = 0
      @scores.each do |score|
        sum += score.technical_total
      end
      return sum/@scores.count
    end

    def entrepreneurship_average
      sum = 0
      @scores.each do |score|
        sum += score.entrepreneurship_total
      end
      return sum/@scores.count
    end

    def pitch_average
      sum = 0
      @scores.each do |score|
        sum += score.entrepreneurship_total
      end
      return sum/@scores.count
    end

    def overall_impression_average
      sum = 0
      @scores.each do |score|
        sum += score.overall_impression_total
      end
      return sum/@scores.count
    end

    def best_category
      adjusted_scores = {"Ideation": (ideation_average * 25/15),
                         "Technical": technical_average,
                         "Entrepreneurship": entrepreneurship_average,
                         "Pitch": pitch_average,
                         "Overall Impression": (overall_impression_average * 20/25)}

     return adjusted_scores.max_by{|key,value| value}[0]
    end

  end
end
