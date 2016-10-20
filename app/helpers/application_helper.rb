module ApplicationHelper
  def al(path)
    request.fullpath == path ? "active" : ""
  end

  def locale_names
    I18n.available_locales.map do |locale|
      [I18n.t('language', locale: locale), locale.to_s]
    end
  end
end
