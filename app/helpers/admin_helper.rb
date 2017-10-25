module AdminHelper
  def show_percentage(num_collection, denom_collection)
    content_tag :small do
        "(" +
          number_to_percentage(
            (num_collection.count / denom_collection.count.to_f) * 100,
            precision: 0
          ) +
        ")"
    end
  end
end
