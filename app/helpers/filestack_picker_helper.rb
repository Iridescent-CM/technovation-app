module FilestackPickerHelper
  def filestack_picker_options(record)
    {
      accept: ["image/jpeg", "image/jpg", "image/png"],
      uploadConfig: {
        intelligent: true
      },
      customText: {
        "Select Files to Upload": "Select Files to Upload (Max 2MB)"
      },
      maxSize: 2 * 1024 * 1024, # 2 MB LIMIT
      fromSources: ["local_file_system"],
      onFileSelected: "onFileSelected",
      onFileUploadFinished: "onFileUploadFinished",
      storeTo: {
        location: "s3",
        container: ENV.fetch("AWS_BUCKET_NAME"),
        path: aws_path(record),
        region: "us-east-1"
      }
    }
  end

  private

  def aws_path(record)
    if record.is_a?(TeamSubmission)
      "uploads/screenshot/filestack/#{record.id}/"
    elsif record.is_a?(Team)
      "uploads/team/team_photo/#{record.id}/"
    end
  end
end
