module SignIn
  def self.call(signin, context, options = {})
    signin_options = {
      message: I18n.translate('controllers.signins.create.success'),
      redirect_to: after_signin_path(signin, context),
      permanent: false,
    }.merge(options)

    context.set_cookie(
      CookieNames::AUTH_TOKEN,
      signin.auth_token,
      permanent: options[:permanent]
    )

    context.remove_cookie(CookieNames::SIGNUP_TOKEN)
    context.remove_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)

    RegisterToCurrentSeasonJob.perform_later(signin)

    RecordBrowserDetailsJob.perform_later(
      signin.id,
      context.request.remote_ip,
      context.request.user_agent
    )

    RecordLoginTimeJob.perform_later(
      signin.id,
      Time.current.to_i
    )

    context.redirect_to(
      (context.remove_cookie(CookieNames::REDIRECTED_FROM) or
        context.send(*Array(signin_options[:redirect_to]))),
      success: signin_options[:message]
    )
  end

  private
  def self.after_signin_path(signin, context)
    last_profile_used = context.remove_cookie(CookieNames::LAST_PROFILE_USED)

    if last_profile_used and
        not signin.public_send("#{last_profile_used}_profile").present?
      last_profile_used = nil
    end

    (last_profile_used && "#{last_profile_used}_dashboard_path") or
      "#{signin.scope_name.sub(/^\w+_regional/, "regional")}_dashboard_path"
    # TODO --- root out this pending chapter ambassador stuff into something
    # sensible
  end
end
