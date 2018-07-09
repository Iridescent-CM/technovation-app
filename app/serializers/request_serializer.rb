class RequestSerializer
  include FastJsonapi::ObjectSerializer
  attributes :requestor_avatar,
    :requestor_name,
    :requestor_meta,
    :requestor_message,
    :request_type,
    :request_status

  attribute :urls do |request|
    {
      patch: Rails.application.routes.url_helpers.admin_request_url(request),
    }
  end
end
