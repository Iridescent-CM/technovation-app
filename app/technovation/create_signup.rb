module CreateSignup
  def self.call(params)
    role_name = Role.registerable_name(params.delete(:registration_role))
    "Create#{role_name.capitalize}".constantize.(params)
  end
end
