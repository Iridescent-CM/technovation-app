module ProfileCompletion
  class Link < Struct.new(:step_id, :name, :url_structure, :link_options, :tag_options)
    include Rails.application.routes.url_helpers

    def text
      I18n.t("views.profile_requirements.#{step_id}.links.#{name}.text")
    end

    def url(urls)
      if url = urls.find { |k, _| String(k) == step_id }
        url[1]
      else
        case url_structure
        when Array
          send(url_structure.first, Hash[*url_structure.last])
        when /_path\z/
          send(url_structure)
        else
          url_structure
        end
      end
    end

    def prefix
      if !!Hash(link_options)[:prefix_path]
        I18n.t("views.profile_requirements.#{step_id}.links.#{name}.prefix_text")
      end
    end

    def postfix
      if !!Hash(link_options)[:postfix_path]
        I18n.t("views.profile_requirements.#{step_id}.links.#{name}.post_text")
      end
    end

    def options
      Hash(tag_options)
    end
  end
end
