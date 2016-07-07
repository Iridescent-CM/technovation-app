module SignIn
  def self.call(signin, context, options = {})
    signin_options = {
      message: I18n.translate('controllers.signins.create.success'),
      redirect: after_signin_path(signin, context),
    }.merge(options)

    context.set_cookie(:auth_token, signin.auth_token)
    RegisterToCurrentSeasonJob.perform_later(signin)
    context.redirect_to signin_options[:redirect],
                        success: signin_options[:message]
  end

  private
  def self.after_signin_path(signin, context)
    context.get_cookie(:redirected_from) or
      determine_dashboard_path(signin, context)
  end

  def self.determine_dashboard_path(signin, context)
    type = DetermineAccountType.(signin.auth_token)
    context.public_send("#{type}_dashboard_path")
  end
end
