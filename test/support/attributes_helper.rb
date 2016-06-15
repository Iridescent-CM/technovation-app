module AttributesHelper
  def auth_attributes(attrs = {})
    pwd = attrs.fetch(:password) { "auth@example.com" }
    { email: pwd,
      password: pwd,
      password_confirmation: pwd }.merge(attrs)
  end
end
