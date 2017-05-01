module ResetPasswordToEmail
  def self.call(email)
    a = Account.find_by(email: email)
    a.update_attributes(skip_existing_password: true,
                        password: email)
    puts "#{a.email} password is now #{email}"
  end
end
