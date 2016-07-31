class ExistsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Account.exists?(attribute => value)
      record.errors.add(attribute, :not_found)
    end
  end
end
