class ApplicationValidator < ActiveModel::EachValidator
  private
  def translation_path(record, attribute)
    %W(activerecord
       errors
       models
       #{record.class.name.underscore}
       attributes
       #{attribute}
       invalid).join('.')
  end
end
