class RegionalLink < ApplicationRecord
  enum name: %i{
    twitter
    facebook
    youtube
    linkedin
    instagram
    snapchat
    whatsapp
    website
  }

  belongs_to :regional_ambassador_profile

  before_save -> {
    self.value = value.gsub('@', '')
      .gsub(/^\+/, '')
      .sub('http:', 'https:')
      .strip
  }

  def self.link_name_placeholders
    {
      twitter: "@username",
      facebook: "https://facebook.com/page-name",
      youtube: "https://youtube.com/user/channel-name",
      linkedin: "https://linkedin.com/in/username",
      instagram: "@username",
      snapchat: "@username",
      whatsapp: "52 1 33 23 10 69 05",
      website: "https://www.example.org",
    }
  end

  def icon
    case name
    when "twitter", "linkedin", "facebook"
      "#{name}-square"
    when "website"
      "earth"
    else
      name
    end
  end

  def display_text
    case name
    when "twitter", "instagram", "snapchat"
      detect_page_name_from_url(value, prefix: "@")
    when "website"
      value
    else
      detect_page_name_from_url(value)
    end
  end

  def url
    case value
    when /^https/
      value
    else
      urlify(value)
    end
  end

  private
  def urlify(value)
    if value.include?(name)
      "https://#{value}"
    else
      "https://#{url_formats[name]}#{value}"
    end
  end

  def url_formats
    {
      twitter: "www.twitter.com/",
      facebook: "www.facebook.com/",
      youtube: "www.youtube.com/user/",
      linkedin: "www.linkedin.com/in/",
      instagram: "www.instagram.com/",
      snapchat: "www.snapchat.com/add/",
      whatsapp: "api.whatsapp.com/send?phone=",
      website: "",
    }.with_indifferent_access
  end

  def detect_page_name_from_url(value, passed_options = {})
    default_options = {
      prefix: "",
    }

    options = default_options.merge(passed_options)

    if match = value.match(/\w+\/(.+)$/)
      options[:prefix] + match[1]
    else
      options[:prefix] + value
    end
  end
end
