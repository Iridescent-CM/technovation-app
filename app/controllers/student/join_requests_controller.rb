class Student::JoinRequestsController < StudentController
  def update
    join_request = JoinRequest.find(params.fetch(:id))
    join_request.public_send("#{params.fetch(:status)}!")

    redirect_to :back, success: t("controllers.student.join_requests.update.success",
                                  name: join_request.requestor_full_name,
                                  status: params.fetch(:status))
  end
end
