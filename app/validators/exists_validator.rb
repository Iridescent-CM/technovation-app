class ExistsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless !!value && Account.where("lower(#{attribute}) = ?", value.downcase).first.present?
      record.errors.add(attribute, :not_found)
    end
  end
end
