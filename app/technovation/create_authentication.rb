module CreateAuthentication
  def self.call(attrs)
    auth_attrs = attrs.deep_merge(judge_profile_attributes: {
      expertise_ids: attrs.fetch(:judge_profile_attributes) { { } }
                          .fetch(:expertise_ids) { [] }
                          .reject(&:blank?)
    })
    auth = Authentication.new(auth_attrs)
    GenerateToken.(auth, :auth_token)
    auth.save
    auth
  end
end
