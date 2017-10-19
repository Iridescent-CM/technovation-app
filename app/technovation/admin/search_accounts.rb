module Admin
  class SearchAccounts
    def self.call(params)
      params[:type] = "All" if params[:type].blank?
      params[:how_heard] = "All" if params[:how_heard].blank?
      params[:team_status] = "All" if params[:team_status].blank?
      params[:cleared_status] = "All" if params[:cleared_status].blank?
      params[:season] = Season.current.year if params[:season].blank?
      params[:country] = "All" if params[:country].blank?

      if params[:parental_consent_status].blank?
        params[:parental_consent_status] = "All" 
      end

      klass = if params[:type] == "All"
                Account
              else
                Account.joins("#{params[:type].underscore}_profile".to_sym)
              end

      accounts = klass.by_season(params[:season])
        .where.not(email: ENV.fetch("ADMIN_EMAIL"))

      unless params[:text].blank?
        names = params[:text].split(' ')
        accounts = accounts.where(
          "accounts.first_name ilike '%#{names.first}%' OR
          accounts.last_name ilike '%#{names.last}%' OR
          accounts.email ilike '%#{names.first}%'"
        )
      end

      unless params[:how_heard] == "All"
        accounts = accounts.where(
          referred_by: Account.referred_bies[params[:how_heard]]
        )
      end

      unless params[:country] == "All"
        accounts = accounts.where(country: params[:country])
      end

      if params[:type] == "Student"
        case params[:parental_consent_status]
        when "Signed"
          accounts = accounts.joins(student_profile: :parental_consent)
        when "Sent"
          accounts = accounts.includes(student_profile: :parental_consent)
            .references(:parental_consents)
            .where(
              "parental_consents.id IS NULL AND
               student_profiles.parent_guardian_email IS NOT NULL"
            )
        when "No Info Entered"
          accounts = accounts.includes(student_profile: :parental_consent)
            .references(:parental_consents)
            .where(
              "parental_consents.id IS NULL AND
              student_profiles.parent_guardian_email IS NULL"
            )
        end
      end

      if params[:type] == "Mentor"
        case params[:cleared_status]
        when "Clear"
          accounts = accounts.includes(:background_check)
            .references(:background_checks)
            .where(
              "country != 'US' OR
              background_checks.status = ?",
              BackgroundCheck.statuses[:clear]
            )
        when "Needs background check"
          accounts = accounts.includes(:background_check)
            .references(:background_checks)
            .where("country = 'US' AND
                    background_checks.id IS NULL")
        when "Needs consent waiver"
          accounts = accounts.includes(:consent_waiver)
            .references(:consent_waivers)
            .where("consent_waivers.id IS NULL OR
                    consent_waivers.voided_at IS NOT NULL")
        end
      end

      case params[:team_status]
      when "On a team"
        accounts = accounts.joins(:current_teams)
      when "No team"
        accounts = accounts.left_outer_joins(:current_teams)
          .where("teams.id IS NULL")
      end

      accounts.distinct
    end
  end
end
