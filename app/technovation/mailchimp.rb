module Mailchimp
  class MailingList
    include HTTParty

    base_uri "https://#{ENV.fetch('MAILCHIMP_API_KEY').last(3)}.api.mailchimp.com/3.0/lists"
    basic_auth "any", ENV.fetch('MAILCHIMP_API_KEY')

    def initialize(list_scope)
      @enabled = ENV.fetch("ENABLE_MAILING_LISTS", false)
      @list_id = ENV.fetch("#{list_scope.to_s.upcase}_LIST_ID")
    end

    def subscribe(email, merge_fields = {})
      wrap("subscribe user to list #{@list_id}") do 
        self.class.post(
          "/#{@list_id}/members",
          {
            body: JSON.generate({
              email_address: email,
              status: "subscribed",
              merge_fields: merge_fields
            })
          }
        )
      end
    end

    def update(email_was, email, merge_fields = {})
      wrap("update user on list #{@list_id}") do
        self.class.patch(
          "/#{@list_id}/members/#{hash(email_was)}",
          {
            body: JSON.generate({
              email_address: email,
              merge_fields: merge_fields
            })
          }
        )
      end
    end

    def delete(email)
      wrap("delete user from list #{@list_id}") do
        self.class.delete("/#{@list_id}/members/#{hash(email)}")
      end
    end

    private

    def hash(email)
      Digest::MD5.hexdigest(email.downcase)
    end

    def wrap(msg)
      if @enabled
        response = yield
        handle_response(response)
      else
        Rails.logger.info "[ENABLE_MAILING_LISTS=#{@enabled}]: #{msg}"
      end
    end

    def handle_response(response)
      case response.code
      when 400...500
        raise APIRequestError.new(response)
      when 500...600
        raise APIServerError.new(response)
      else
        response.parsed_response
      end
    end
  end

  class APIError < StandardError
    attr_reader :response

    def initalize(response)
      @response = response
      super(response)
    end
  end
  class APIRequestError < APIError; end
  class APIServerError < APIError; end
end