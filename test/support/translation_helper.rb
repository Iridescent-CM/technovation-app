module TranslationHelper
  def translated_error(model_name, attribute_name, error_name)
    I18n.translate("activerecord.errors.models.#{model_name}.attributes.#{attribute_name}.#{error_name}")
  end
end
