module PhotoUploadConfirmationController
  extend ActiveSupport::Concern

  def show
    ProcessUploadJob.perform_later(
      upload.model_id,
      upload.model_name,
      upload.field_name,
      params.fetch(:key)
    )

    flash.now[:success] = upload.success_msg

    url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"

    @unprocessed_photo_url = url

    @uploader = ImageUploader.new
    @uploader.success_action_redirect = upload.redirect_url

    @size = upload.size
    @heading = upload.heading

    render template: "image_upload_confirmations/show"
  end

  private
  def upload
    "photo_upload_confirmation_controller/#{photo_name}_upload".camelize
      .constantize.new(self)
  end

  def photo_name
    self.class.name.underscore.split("/").last
      .sub("_upload_confirmations_controller", "")
  end

  class ProfileImageUpload
    def initialize(context)
      @context = context
      @model = context.current_account
      @scope = context.current_scope
    end

    def model_id
      @model.id
    end

    def model_name
      @model.class.name
    end

    def field_name
      "profile_image"
    end

    def success_msg
      I18n.t("controllers.accounts.show.image_processing")
    end

    def redirect_url
      @context.send("#{@scope}_profile_image_upload_confirmation_url")
    end

    def size
      "300x300"
    end

    def heading
      "Upload a profile photo"
    end
  end

  class TeamPhotoUpload
    def initialize(context)
      @context = context
      @model = context.current_team
      @scope = context.current_scope
    end

    def model_id
      @model.id
    end

    def model_name
      @model.class.name
    end

    def field_name
      "team_photo"
    end

    def success_msg
      I18n.t("controllers.teams.show.image_processing")
    end

    def redirect_url
      @context.send("#{@scope}_team_photo_upload_confirmation_url",
        team_id: model_id,
        back: @context.send("#{@scope}_team_path", @model)
      )
    end

    def size
      "450x300"
    end

    def heading
      "Upload a team photo"
    end
  end
end
