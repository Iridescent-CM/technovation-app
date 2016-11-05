module SignIn
  def self.call(signin, context, options = {})
    signin_options = {
      message: I18n.translate('controllers.signins.create.success'),
      redirect_to: after_signin_path(signin, context),
    }.merge(options)

    context.set_cookie(:auth_token, signin.account.auth_token)
    context.remove_cookie(:signup_token)

    RegisterToCurrentSeasonJob.perform_later(signin)

    if context.request.remote_ip != signin.account.last_login_ip
      signin.account.update_attributes(last_login_ip: context.request.remote_ip)
    end

    context.redirect_to signin_options[:redirect_to],
                        success: signin_options[:message]
  end

  private
  def self.after_signin_path(signin, context)
    context.remove_cookie(:redirected_from) or
      context.public_send("#{signin.type_name}_dashboard_path")
  end
end
