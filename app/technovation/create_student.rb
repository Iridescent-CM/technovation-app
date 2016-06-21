module CreateStudent
  def self.call(attrs)
    CreateAuthentication.(attrs)
  end
end

