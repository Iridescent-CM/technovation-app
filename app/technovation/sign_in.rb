module SignIn
  def self.call(signin, context, options = {})
    signin_options = {
      message: I18n.translate('controllers.signins.create.success'),
      redirect_to: after_signin_path(signin, context),
    }.merge(options)

    context.set_cookie(:auth_token, signin.auth_token)
    context.remove_cookie(:signup_token)
    context.remove_cookie(:admin_permission_token)

    RegisterToCurrentSeasonJob.perform_later(signin)
    RecordBrowserDetailsJob.perform_later(signin.id,
                                          context.request.remote_ip,
                                          context.request.user_agent)

    context.redirect_to(
      (context.remove_cookie(:redirected_from) or
        context.send(signin_options[:redirect_to])),
      success: signin_options[:message]
    )
  end

  private
  def self.after_signin_path(signin, context)
    last_profile_used = context.remove_cookie(:last_profile_used)

    if last_profile_used and
        not signin.public_send("#{last_profile_used}_profile").present?
      last_profile_used = nil
    end

    (last_profile_used && "#{last_profile_used}_dashboard_path") or
        "#{signin.type_name}_dashboard_path"
  end
end
