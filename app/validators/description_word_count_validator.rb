class DescriptionWordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.split(" ").count > 100
      record.errors.add(attribute, "#{I18n.t('views.team_submissions.form.additional_info_word_count_help')}")
    end
  end
end
