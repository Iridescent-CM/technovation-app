module ProfileImageUploadConfirmationController
  extend ActiveSupport::Concern

  def show
    ProcessUploadJob.perform_later(
      current_account.id,
      'Account',
      "profile_image",
      params.fetch(:key)
    )

    flash.now[:success] = t("controllers.accounts.show.image_processing")

    @unprocessed_photo_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"

    @size = "300x300"
    @heading = "Upload a profile photo"

    @uploader = ImageUploader.new
    @uploader.success_action_redirect = send(
      "#{current_scope}_profile_image_upload_confirmation_url"
    )

    render template: "profile_image_upload_confirmations/show"
  end
end
