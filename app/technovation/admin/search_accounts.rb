module Admin
  class SearchAccounts
    def self.call(params)
      params[:type] = "All" if params[:type].blank?
      params[:parental_consent_status] = "All" if params[:parental_consent_status].blank?
      params[:season] = Season.current.year if params[:season].blank?

      klass = if params[:type] == "All"
                Account
              else
                "#{params[:type]}Account".constantize
              end

      accounts = klass.joins(season_registrations: :season)
                      .where("season_registrations.season_id = ?",
                             Season.find_by(year: params[:season]))

      unless params[:text].blank?
        client = Swiftype::Client.new
        results = client.search(ENV.fetch('SWIFTYPE_ENGINE_SLUG'),
                                params[:text],
                                document_types: ["adminaccounts"],
                                per_page: 100)
        accounts = accounts.where(id: results['adminaccounts'].collect { |h| h['external_id'] })
      end

      if params[:type] == "Student"
        case params[:parental_consent_status]
        when "Signed"
          accounts = accounts.joins(:parental_consent)
        when "Sent"
          accounts = accounts.includes(:parental_consent)
                             .references(:parental_consents)
                             .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NOT NULL")
        when "Not Configured"
          accounts = accounts.includes(:parental_consent)
                             .references(:parental_consents)
                             .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NULL")
        end
      end

      accounts
    end
  end
end
