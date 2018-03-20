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

  def before_submissions_are_open(&block)
    if Date.current < Date.new(2018, 4, 25)
      yield
    end
  end

  def locale_names
    I18n.available_locales.map do |locale|
      [I18n.t('language', locale: locale), locale.to_s]
    end
  end

  def web_icon(icon, options = {})
    if !!options[:remote]
      url = "https://icongr.am/fontawesome/"
      url += "#{icon}.svg"
      url += "?size=#{options[:size]}"
      url += "&color=#{options[:color]}"

      content_tag(:span) do
        img = content_tag(:img, nil, src: url)

        text = content_tag(
          :span,
          options[:text],
          class: "icomoon--icon-text"
        )

        img + text
      end
    else
      css = (options[:class] || "").split(" ").map do |class_name|
        if class_name.match(/^icon-/)
          "icomoon--#{class_name}"
        else
          class_name
        end
      end

      content_tag(:span) do
        icon = content_tag(
          :span,
          nil,
          class: "icomoon--icon-#{icon} #{css.join(" ")}"
        )

        text = content_tag(
          :span,
          options[:text],
          class: "icomoon--icon-text"
        )

        icon + text
      end
    end
  end

  def fa_icon(*args)
    ActiveSupport::Deprecation.warn(
      "#fa_icon is deprecated. Please use #web_icon"
    )
    web_icon(*args)
  end
end
