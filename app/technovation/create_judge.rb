module CreateJudge
  def self.call(attrs)
    CreateAuthentication.(attrs)
  end
end
