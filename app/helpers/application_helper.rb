module ApplicationHelper
  SCOPES = %w{
    student
    mentor
    judge
    regional_ambassador
  }

  def determine_manifest
    namespace = controller_path.split("/").first

    if current_account.authenticated? and SCOPES.include?(namespace)
      namespace
    elsif current_account.authenticated?
      current_account.scope_name
    else
      :public
    end
  end

  def al(identifiers)
    decoded_path = URI::decode(request.fullpath)

    if Array(identifiers).any? { |i| decoded_path.include?(i) }
      "active"
    else
      ""
    end
  end

  def locale_names
    I18n.available_locales.map do |locale|
      [I18n.t('language', locale: locale), locale.to_s]
    end
  end

  def web_icon(icon, options = {})
    content_tag(:span) do
      content_tag(:span, nil, class: "icon-#{icon} #{options[:class]}") +
        options[:text]
    end
  end

  def fa_icon(*args)
    ActiveSupport::Deprecation.warn(
      "#fa_icon is deprecated. Please use #web_icon"
    )
    web_icon(*args)
  end
end
