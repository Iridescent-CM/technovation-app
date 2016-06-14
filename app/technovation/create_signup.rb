module CreateSignup
  def self.call(params)
    judge = CreateJudge.(params)
    Signup.new(judge.authentication.attributes)
  end
end
