class ScratchShareUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.match(/^https?:\/\/scratch.mit.edu\/projects\/.+$/)
      record.errors.add(attribute, :invalid)
    end
  end
end
