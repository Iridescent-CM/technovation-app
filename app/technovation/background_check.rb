module BackgroundCheck
  def request_path
    "/#{api_version}/#{resource_name}"
  end

  def api_version
    "v1"
  end

  def api_class
    Checkr
  end
end
