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

    def update
      request = Request.find(params.fetch(:id))
      SetRequestStatus.(request, request_params[:request_status])
      render json: RequestSerializer.new(request).serialized_json
    end

    private
    def request_params
      params.require(:request).permit(:request_status)
    end
  end
end