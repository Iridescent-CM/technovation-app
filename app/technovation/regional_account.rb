module RegionalAccount
  def self.call(ambassador, params = {})
    klass = if params[:type] == "All"
              Account
            else
              "#{params[:type]}Account".constantize
            end

    accounts = klass.includes(:seasons)
                    .references(:seasons)
                    .where("seasons.year = ?", Season.current.year)
                    .where.not(type: "AdminAccount")

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

    if params[:type] == "Student"
      accounts = case params[:parental_consent_status]
                 when "Signed"
                   accounts.joins(:parental_consent)
                 when "Sent"
                   accounts.includes(:parental_consent)
                           .references(:parental_consents)
                           .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NOT NULL")
                 when "No Info Entered"
                   accounts.where("student_profiles.parent_guardian_email IS NULL")
                 else
                   accounts
                 end
    end

    if ambassador.country == "US"
      accounts.where(state_province: ambassador.state_province)
    else
      accounts.where(country: ambassador.country)
    end
  end
end
