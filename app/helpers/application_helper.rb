module ApplicationHelper
  def browser_title
    title = content_for?(:page_title) ? "#{yield(:page_title)} – " : ""
    title += t('views.application.site_title')
  end

  def page_description
    if content_for?(:page_description)
      yield(:page_description)
    else
      "Every year, Technovation invites teams of girls from all over the world to learn and apply the skills needed to solve real-world problems through technology. Be a part of the community."
    end
  end

  def al(path)
    request.fullpath == path ? "active" : ""
  end

  def locale_names
    I18n.available_locales.map do |locale|
      [I18n.t('language', locale: locale), locale.to_s]
    end
  end
end
