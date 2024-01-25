module ApplicationHelper
  SCOPES = %w[
    student
    mentor
    judge
    chapter_ambassador
  ]

  def safe_time_ago_in_words(time, postfix = nil)
    if time
      time_ago_in_words(time) + (" #{postfix}" if postfix)
    else
      "never"
    end
  end

  def determine_manifest
    namespace = controller_path.split("/").first
    path = controller_path.split("/").second

    if namespace == "chapter_ambassador" && (path == "dashboards" || path == "profiles" || path == "location_details")
      :student
    elsif current_account.authenticated? && SCOPES.include?(namespace)
      namespace
    elsif current_account.authenticated?
      current_account.scope_name
    else
      :public
    end
  end

  def al(identifiers)
    decoded_path = CGI.escape(request.fullpath)

    if Array(identifiers).any? { |i| decoded_path.include?(CGI.escape(i)) }
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
      [I18n.t("language", locale: locale), locale.to_s]
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
          class: "web-icon-text"
        )

        img + text
      end
    else
      content_tag(:span) do
        icon = content_tag(
          :span,
          nil,
          class: "icon-#{icon} #{options[:class]}"
        )

        text = content_tag(
          :span,
          options[:text],
          class: "web-icon-text"
        )

        icon + text
      end
    end
  end

  def fa_icon(*args) # standard:disable all
    ActiveSupport::Deprecation.warn(
      "#fa_icon is deprecated. Please use #web_icon"
    )
    web_icon(*args) # standard:disable all
  end

  def determine_homepage_content
    if SeasonToggles.judging_enabled_or_between?
      render partial: "judging_open_splash"
    elsif SeasonToggles.registration_open?
      render partial: "landing"
    else
      render partial: "off_season_splash"
    end
  end
end
