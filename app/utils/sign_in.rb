module SignIn
  def self.call(signin, context, options = {})
    signin_options = {
      message: I18n.translate('controllers.signins.create.success'),
      redirect: context.after_signin_path,
    }.merge(options)

    context.set_cookie(:auth_token, signin.auth_token)
    RegisterToCurrentSeasonJob.perform_later(signin)
    context.redirect_to signin_options[:redirect],
                        success: signin_options[:message]
  end
end
