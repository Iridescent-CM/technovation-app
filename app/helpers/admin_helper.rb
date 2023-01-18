module AdminHelper
  def show_percentage(num_collection, denom_collection)
    "(" +
      number_to_percentage(
        get_percentage(num_collection, denom_collection),
        precision: 0
      ) +
    ")"
  end

  def get_percentage(num_collection, denom_collection, passed_opts = {})
    return 0 if denom_collection.count.zero?

    options = {
      round: 0,
    }.merge(passed_opts)

    ((num_collection.count / denom_collection.count.to_f) * 100)
      .round(options[:round])
  end

  def additional_question_labels(team_submission)
    case team_submission.seasons.last
    when 2021
      [:ai, :climate_change, :game]
    when 2022
      [:ai, :climate_change, :solves_health_problem]
    when 2023
      [:ai, :climate_change, :solves_hunger_or_food_waste, :uses_open_ai]
    end
  end
end
