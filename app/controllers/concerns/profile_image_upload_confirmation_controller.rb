module ProfileImageUploadConfirmationController
  extend ActiveSupport::Concern

  def show
    ProcessUploadJob.perform_later(current_account, "profile_image", params.fetch(:key))
    flash[:success] = t("controllers.accounts.show.image_processing")
    @unprocessed_photo_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
    render template: "profile_image_upload_confirmations/show"
  end
end
