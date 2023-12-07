class MaxWordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    max_word_count = options[:max_word_count] || 100
    if value.split(" ").count > max_word_count
      record.errors.add(attribute, "Your response is too long. Please limit to #{max_word_count} words.")
    end
  end
end
