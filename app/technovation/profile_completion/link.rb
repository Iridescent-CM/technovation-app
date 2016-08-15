require 'json'

module ProfileCompletion
  class Link < Struct.new(:step_id, :name, :config_url, :complete_condition, :link_options, :tag_options)
    include Rails.application.routes.url_helpers if defined?(Rails)

    def text
      I18n.t("views.profile_requirements.#{step_id}.links.#{name}.text")
    end

    def url(urls = {})
      match_from_urls(urls) or
        use_configuration_url
    end

    def prefix
      if !!Hash(link_options)["prefix"]
        I18n.t("views.profile_requirements.#{step_id}.links.#{name}.prefix")
      end
    end

    def postfix
      if !!Hash(link_options)["postfix"]
        I18n.t("views.profile_requirements.#{step_id}.links.#{name}.postfix")
      end
    end

    def options
      Hash(tag_options)
    end

    def completion_state(account)
      if complete_condition
        account.public_send(complete_condition) ? "complete" : ""
      else
        ""
      end
    end

    private
    def match_from_urls(urls)
      urls = JSON.parse(urls.to_json)

      if url = urls.detect do |id, links|
                 id === step_id and links.keys.include?(name)
               end
        url[1].values_at(name)[0]
      end
    end

    def use_configuration_url
      case config_url
      when /_path\z/
        send(config_url)
      else
        config_url
      end
    end
  end
end
