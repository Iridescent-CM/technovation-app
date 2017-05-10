module Legacy::V2::ControllerHelpers
  def legacy_sign_in(profile)
    controller.set_cookie(:auth_token, profile.account.auth_token)
  end
end
