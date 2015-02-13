module SurveyMonkey
  class << self

    def request(*args)
      url, query = url_for(*args.dup)
      options = args.extract_options!.with_indifferent_access
      verbose = !!options.delete(:verbose)

      request_body = (block_given? ? yield : {}).to_json

      response = Typhoeus::Request.post(
        url.to_s,
        body: request_body,
        verbose: verbose,
        params: query,
        headers: { 
          Authorization: 'bearer %s' % token,
          :"Content-Type" => 'application/json'
        }
      )
      puts response.body
      ActiveSupport::JSON.decode response.body
    end

    private
    def token
      SurveyMonkey::Configuration.config.token
    end

    def key
      SurveyMonkey::Configuration.config.key
    end

    def url_for(*args)
      options = args.extract_options!.with_indifferent_access
      options[:query] = options[:query] || HashWithIndifferentAccess.new
      path = args
      options[:query].merge!(:api_key => key)
      api = Rails.application.config.env[:surveymonkey][:api]
      is_ssl = api[:ssl]
      klass = is_ssl ? URI::HTTPS : URI::HTTP
      return [klass.build({
              :host => api[:host], 
              :path => '/' + [api[:path_base], *path].join('/')
            }),options[:query]]
    end
  end
end