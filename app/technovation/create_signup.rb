module CreateSignup
  def self.call(params)
    "Create#{params.delete(:registration_role).capitalize}".constantize.(params)
  end
end
