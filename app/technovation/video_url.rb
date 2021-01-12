class VideoUrl
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def video_id
    case url
    when /youtu/
      url[/(?:youtube(?:-nocookie)?\.com\/(?:[^\/\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/, 1] || ""
    when /vimeo/
      url[/\/(\d+)$/, 1] || ""
    when /youku/
      url[/\/v_show\/id_(\w+)(?:==)?(?:\.html)?.*$/, 1] || ""
    else
      ""
    end
  end

  def root
    case url
    when /youtu/
      "https://www.youtube.com/embed/"
    when /vimeo/
      "https://player.vimeo.com/video/"
    when /youku/
      "https://player.youku.com/embed/"
    end
  end

  def valid?
    video_id.present? && root.present?
  end
end
