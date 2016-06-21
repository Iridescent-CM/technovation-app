module CreateSignup
  def self.call(params)
    role_name = Authentication.registerable_profile(params.delete(:registration_role))
    "Create#{role_name.capitalize}".constantize.(params)
  end
end
