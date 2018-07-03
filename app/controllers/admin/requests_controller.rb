module Admin
  class RequestsController < AdminController
    def index
      Request.create!({
        request_type: "AMBASSADOR_ADD_REGION",
        requestor: RegionalAmbassadorProfile.all.sample,
        target: AdminProfile.all.sample,
        requestor_message: "I want to add these regions because...",
        requestor_meta: {
          regions: ["Ontario, CA", "California, US", "MX"],
        }
      })
      requests = Request.includes(:target, :requestor).all
      render json: RequestSerializer.new(requests).serialized_json
    end
  end
end