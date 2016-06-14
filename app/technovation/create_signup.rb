module CreateSignup
  def self.call(params)
    if (judge = CreateJudge.(params)).authentication.valid?
      judge.authentication
    else
      Signup.new(judge.authentication.attributes)
    end
  end
end
