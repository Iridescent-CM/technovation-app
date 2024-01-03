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
      round: 0
    }.merge(passed_opts)

    ((num_collection.count / denom_collection.count.to_f) * 100)
      .round(options[:round])
  end
end
