module FilestackHelper
  # Partials that render upload UI must call enable_filestack! at the top.
  # See spec/views/filestack_upload_partials_spec.rb when adding a new one.
  def enable_filestack!
    controller.needs_filestack!
  end
end
