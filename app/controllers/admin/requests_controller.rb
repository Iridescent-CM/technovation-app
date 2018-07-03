module Admin
  class RequestsController < AdminController
    def index
      respond_to do |format|
        format.html

        format.json {
          requests = Request.includes(requestor: :account).all
          render json: RequestSerializer.new(requests).serialized_json
        }
      end
    end
  end
end