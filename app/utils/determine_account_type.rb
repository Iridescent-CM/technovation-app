module DetermineAccountType
  def self.call(token)
    unless token.blank?
      %w{student mentor coach judge admin}.detect { |name|
        "#{name}_account".camelize.constantize.find_with_token(token).authenticated?
      }
    end
  end
end
