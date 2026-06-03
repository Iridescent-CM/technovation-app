module SignIn
  def self.call(signin, context, options = {})
    signin_options = {
      message: I18n.translate("controllers.signins.create.success"),
      redirect_to: after_signin_path(signin, context),
      enable_redirect: true,
      permanent: false
    }.merge(options)

    context.set_cookie(
      CookieNames::AUTH_TOKEN,
      signin.auth_token,
      permanent: options[:permanent]
    )

    unless signin.student? && signin.age_by_cutoff > 18
      ChapterableReassigner.new(account: signin).call
      RegisterToCurrentSeasonJob.perform_later(signin)
    end

    RecordBrowserDetailsJob.perform_later(
      signin.id,
      context.request.remote_ip,
      context.request.user_agent
    )

    RecordLoginTimeJob.perform_later(
      signin.id,
      Time.current.to_i
    )

    if signin_options[:enable_redirect] == true
      context.redirect_to(
        (safe_html_redirect_path(context.remove_cookie(CookieNames::REDIRECTED_FROM)) or
          context.send(*Array(signin_options[:redirect_to]))),
        success: signin_options[:message]
      )
    end
  end

  private

  def self.safe_html_redirect_path(path)
    return nil if path.blank?
    return nil if path.match?(/\.(?:json|xml|csv|pdf|xlsx?)(\?|$)/i)

    path
  end
  private_class_method :safe_html_redirect_path

  def self.after_signin_path(signin, context)
    last_profile_used = context.remove_cookie(CookieNames::LAST_PROFILE_USED)

    if last_profile_used and
        !signin.public_send(:"#{last_profile_used}_profile").present?
      last_profile_used = nil
    end

    if last_profile_used.present?
      "#{last_profile_used}_dashboard_path"
    elsif JudgeDashboardRedirector.new(account: signin).enabled?
      "judge_dashboard_path"
    else
      "#{signin.scope_name}_dashboard_path"
    end
  end
end
