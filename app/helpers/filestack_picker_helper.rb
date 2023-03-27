module FilestackPickerHelper
  def filestack_picker_options(object)
    {
      accept: ["image/jpeg", "image/jpg", "image/png"],
      uploadConfig: {
        intelligent: true
      },
      maxSize: 2 * 1024 * 1024, # 2 MB LIMIT
      fromSources: ["local_file_system"],
      onFileSelected: "onFileSelected",
      onFileUploadFinished: "onFileUploadFinished",
      storeTo: {
        location: "s3",
        container: ENV.fetch("AWS_BUCKET_NAME"),
        path: aws_path(object),
        region: "us-east-1"
      }
    }
  end

  def aws_path(object)
    case object
    when TeamSubmission
      "uploads/screenshot/filestack/#{object.id}/"
    end
  end
end
