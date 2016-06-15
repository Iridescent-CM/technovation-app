module CreateSignup
  def self.call(params)
    if (judge_auth = CreateJudge.(params)).valid?
      judge_auth
    else
      Signup.new(judge_auth.attributes)
    end
  end
end
