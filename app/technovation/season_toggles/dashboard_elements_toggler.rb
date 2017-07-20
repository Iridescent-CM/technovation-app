class SeasonToggles
  module DashboardElementsToggler
    def self.extended(base)
      base.extend SurveyLinkMethods
      base.extend HeadlineMethods
    end

    module SurveyLinkMethods
      %w{mentor student}.each do |scope|
        define_method("#{scope}_survey_link=") do |attrs|
          attrs = attrs.with_indifferent_access
          changed = %w{text url}.any? do |key|
            not attrs[key] == survey_link(scope, key)
          end

          if changed
            attrs[:changed_at] = Time.current
            store.set("#{scope}_survey_link", JSON.generate(attrs.to_h))
          end
        end
      end

      def survey_link_available?(scope)
        %w{text url changed_at}.all? do |key|
          !!survey_link(scope, key) and not survey_link(scope, key).empty?
        end
      end

      def show_survey_link_modal?(scope, last_shown)
        survey_link_available?(scope) and
          not survey_link(scope, "changed_at") == last_shown
      end

      def set_survey_link(scope, text, url)
        send("#{scope}_survey_link=", { text: text, url: url })
      end

      def survey_link(scope, key)
        value = store.get("#{scope}_survey_link") || "{}"
        parsed = JSON.parse(value)
        parsed[key.to_s]
      end
    end

    module HeadlineMethods
      %w{mentor student judge}.each do |scope|
        define_method("#{scope}_dashboard_text=") do |text|
          store.set("#{scope}_dashboard_text", text)
        end
      end

      def set_dashboard_text(scope, txt)
        send("#{scope}_dashboard_text=", txt)
      end

      def dashboard_text(scope)
        store.get("#{scope}_dashboard_text")
      end
    end
  end
end
