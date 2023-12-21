module CookiesHelper
  extend ActiveSupport::Concern

  def set_cookie(key, value, passed_options = {})
    default_options = {
      permanent: false
    }

    options = default_options.merge(passed_options)

    if options[:permanent]
      cookies.permanent.signed[key] = {
        value: value,
        domain: request.host
      }
    else
      cookies.signed[key] = {
        value: value,
        domain: request.host
      }
    end
  end

  def get_cookie(key)
    cookies.signed[key] || false
  end

  def remove_cookie(key)
    value = get_cookie(key)
    cookies.delete(key, domain: request.host)
    value
  end
end
