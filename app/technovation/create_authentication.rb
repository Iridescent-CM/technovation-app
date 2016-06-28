module CreateAuthentication
  def self.call(attrs)
    sanitize_attrs!(attrs)
    auth = Authentication.new(attrs)
    GenerateToken.(auth, :auth_token)
    auth.save
    auth
  end

  private
  def self.sanitize_attrs!(attrs)
    attrs.deep_merge!(
      coach_profile_attributes: {
        expertise_ids: attrs.fetch(:coach_profile_attributes) { { } }
                            .fetch(:expertise_ids) { [] }
                            .reject(&:blank?),
      },

      judge_profile_attributes: {
        scoring_expertise_ids: attrs.fetch(:judge_profile_attributes) { { } }
                                    .fetch(:scoring_expertise_ids) { [] }
                                    .reject(&:blank?),
      },

      mentor_profile_attributes: {
        expertise_ids: attrs.fetch(:mentor_profile_attributes) { { } }
                            .fetch(:expertise_ids) { [] }
                            .reject(&:blank?),
      },
    )
  end
end
