class SeasonToggles
  module SurveyLinks
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      %w{mentor student}.each do |scope|
        define_method("#{scope}_survey_link=") do |attrs|
          attrs = attrs.with_indifferent_access
          changed = %w{text long_desc url}.any? do |key|
            not attrs[key] == survey_link(scope, key)
          end

          if changed
            attrs[:changed_at] = Time.current
            store.set("#{scope}_survey_link", JSON.generate(attrs.to_h))
          end
        end
      end

      def survey_link_available?(scope, account = nil)
        link_exists = %w{text url changed_at}.all? do |key|
          !!survey_link(scope, key) and not survey_link(scope, key).empty?
        end

        if account.present?
          not account.took_program_survey? and
            not account.address_details.blank? and
              link_exists
        else
          link_exists
        end
      end

      def show_survey_link_modal?(scope, account)
        survey_link_available?(scope, account) and
          account.needs_survey_reminder?
      end

      def set_survey_link(scope, text, url, long_desc = nil)
        send("#{scope}_survey_link=", { text: text, long_desc: long_desc, url: url })
      end

      def survey_link(scope, key, opts = {})
        options = {
          format_url: false,
          account: ::NullAccount.new,
        }.merge(opts)

        value = store.get("#{scope}_survey_link") || "{}"
        parsed = JSON.parse(value)

        if options[:format_url]
          format_parsed_url(parsed[key.to_s], options[:account])
        else
          parsed[key.to_s]
        end
      end

      private
      def format_parsed_url(parsed_url, account)
        unless parsed_url.blank?
          formatted_url = parsed_url.dup
          formatted_url.sub!("[uid_value]", account.id.to_s)
          formatted_url.sub!("[email_value]", account.email)
          formatted_url.sub!("[country_value]", FriendlyCountry.(account))
          formatted_url.sub!("[state_value]", FriendlySubregion.(account))
          formatted_url.sub!("[name_value]", account.full_name)
          formatted_url.sub!("[city_value]", account.city || "")
          formatted_url.sub!("[age_value]", account.age.to_s)
          formatted_url.sub!("[school_value]", account.profile_school_company_name)
          formatted_url.sub!("[company_value]", account.profile_school_company_name)

          team_replacement = if account.profile_teams.any?
            account.profile_team_names.join(", ")
          else
            ""
          end

          formatted_url.sub!("[team_value]", team_replacement)

          formatted_url
        end
      end
    end
  end
end
