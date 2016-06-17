module CreateStudent
  def self.call(attrs)
    auth = CreateAuthentication.(attrs.merge(role: Role.student))

    if auth.valid?
      auth.student_role.create_student_profile(
        parent_guardian_email: attrs.fetch(:parent_guardian_email),
        date_of_birth: attrs.fetch(:date_of_birth)
      )
    end

    auth
  end
end

