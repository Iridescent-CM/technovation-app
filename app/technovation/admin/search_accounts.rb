module Admin
  class SearchAccounts
    def self.call(params)
      params[:type] = "All" if params[:type].blank?
      params[:how_heard] = "All" if params[:how_heard].blank?
      params[:parental_consent_status] = "All" if params[:parental_consent_status].blank?
      params[:season] = Season.current.year if params[:season].blank?

      klass = if params[:type] == "All"
                Account
              else
                Account.joins("#{params[:type].underscore}_profile".to_sym)
              end

      accounts = klass.joins(season_registrations: :season)
        .where("season_registrations.season_id = ?", Season.find_by(year: params[:season]))
        .where.not(email: "info@technovationchallenge.org")

      unless params[:text].blank?
        results = accounts.search(
          query: {
            query_string: {
              query: "*#{params[:text]}*"
            }
          },
          from: 0,
          size: 10_000,
        ).results
        accounts = accounts.where(id: results.flat_map { |r| r._source.id })
      end

      unless params[:how_heard] == "All"
        accounts = accounts.where(referred_by: Account.referred_bies[params[:how_heard]])
      end

      if params[:type] == "Student"
        case params[:parental_consent_status]
        when "Signed"
          accounts = accounts.joins(:parental_consent)
        when "Sent"
          accounts = accounts.includes(:parental_consent)
                             .references(:parental_consents)
                             .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NOT NULL")
        when "No Info Entered"
          accounts = accounts.includes(:parental_consent)
                             .references(:parental_consents)
                             .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NULL")
        end
      end

      accounts
    end
  end
end
