class SurveyMonkey::Configuration
  attr_accessor :key, :token

  class << self
    attr_reader :config

    def configure
      @config ||= new
      yield(@config)
      @config
    end

    def load!
      data = Rails.application.config.env[:surveys]
      configure do |c|
        c.key = data[:key].try(:to_s)
        c.token = data[:token].try(:to_s)
      end
    end

  end

end
