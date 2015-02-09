module SurveyMonkey
  class << self

    def request(*args)
      url = url_for(*args.dup)
      options = args.extract_options!.with_indifferent_access
      verbose = !!options.delete(:verbose)

      args = [url.to_s]
      args.push({:ssl => {:ca_path => (Rails.root + 'config' + 'certs' + 'ca-bundle.crt').to_s}}) if url.kind_of? URI::HTTPS
      request = Faraday::Connection.new(*args) do |request|
        yield(request) if block_given?
        request.headers['Authorization'] = 'bearer %s' % token
        request.headers['Content-Type'] = 'application/json'
        request.adapter Faraday.default_adapter 
      end
      puts request.inspect if verbose
      request_body = (block_given? ? yield : {}).to_json
      ActiveSupport::JSON.decode request.post('', request_body).body
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
      klass.build({
        :host => api[:host], 
        :path => '/' + [api[:path_base], *path].join('/'), 
        :query => options[:query].to_query,
      })
    end
  end
end