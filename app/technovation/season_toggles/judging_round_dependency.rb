class SeasonToggles
  module JudgingRoundDependency
    @@blocked_by_judging_topics = []

    def judging_must_be_off(key, options = {})
      @@blocked_by_judging_topics << options[:topic]

      define_singleton_method("#{key}=") do |value|
        if judging_enabled?
          if convert_to_bool(value)
            warn_about_judging_enabled(options[:topic])
          end

          super(false)
        else
          super(value)
        end
      end

      define_singleton_method("#{key}?") do
        not judging_enabled? and super()
      end
    end

    def warn_about_judging_enabled(topic = nil)
      unless Rails.env.test?
        topic ||= @@blocked_by_judging_topics.join(", ")
        warn("JUDGING IS ENABLED: Setting #{topic} to FALSE")
      end
    end
  end
end
