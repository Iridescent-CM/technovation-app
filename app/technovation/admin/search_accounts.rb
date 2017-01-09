module Admin
  class SearchAccounts
    def self.call(params)
      params[:type] = "All" if params[:type].blank?
      params[:how_heard] = "All" if params[:how_heard].blank?
      params[:parental_consent_status] = "All" if params[:parental_consent_status].blank?
      params[:team_status] = "All" if params[:team_status].blank?
      params[:cleared_status] = "All" if params[:cleared_status].blank?
      params[:season] = Season.current.year if params[:season].blank?

      season = Season.find_by(year: params[:season])

      klass = if params[:type] == "All"
                Account
              else
                Account.joins("#{params[:type].underscore}_profile".to_sym)
              end

      accounts = klass.joins(season_registrations: :season)
        .where("season_registrations.season_id = ?", season.id)
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
          accounts = accounts.joins(student_profile: :parental_consent)
        when "Sent"
          accounts = accounts.includes(student_profile: :parental_consent)
                             .references(:parental_consents)
                             .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NOT NULL")
        when "No Info Entered"
          accounts = accounts.includes(student_profile: :parental_consent)
                             .references(:parental_consents)
                             .where("parental_consents.id IS NULL AND student_profiles.parent_guardian_email IS NULL")
        end
      end

      if params[:type] == "Mentor"
        case params[:team_status]
        when "On a team"
          accounts = accounts.where("mentor_profiles.id IN
            (SELECT DISTINCT(member_id) FROM memberships
                                        WHERE memberships.member_type = 'MentorProfile'
                                        AND memberships.joinable_type = 'Team'
                                        AND memberships.joinable_id IN

              (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

                (SELECT DISTINCT(registerable_id) FROM season_registrations
                                                  WHERE season_registrations.registerable_type = 'Team'
                                                  AND season_registrations.season_id = ?)))", season.id)
        when "No team"
          accounts = accounts.where("mentor_profiles.id NOT IN
            (SELECT DISTINCT(member_id) FROM memberships
                                        WHERE memberships.member_type = 'MentorProfile'
                                        AND memberships.joinable_type = 'Team'
                                        AND memberships.joinable_id IN

              (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

                (SELECT DISTINCT(registerable_id) FROM season_registrations
                                                  WHERE season_registrations.registerable_type = 'Team'
                                                  AND season_registrations.season_id = ?)))", season.id)
        end

        case params[:cleared_status]
        when "Clear"
          accounts = accounts.joins(:consent_waiver)
            .includes(:background_check)
            .references(:background_checks)
            .where("country != 'US' OR
                    background_checks.status = ?",
                   BackgroundCheck.statuses[:clear])
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

      accounts
    end
  end
end
