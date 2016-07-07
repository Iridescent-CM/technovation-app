module DetermineLayout
  def self.call(token)
    %w{student mentor coach judge admin}.detect { |name|
      "#{name}_account".camelize.constantize.find_with_token(token).authenticated?
    }
  end
end
