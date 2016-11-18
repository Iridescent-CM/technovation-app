module Admin
  class SearchAccounts
    def self.call(params)
      params[:type] = "All" if params[:type].blank?
      params[:how_heard] = "All" if params[:how_heard].blank?
      params[:parental_consent_status] = "All" if params[:parental_consent_status].blank?
      params[:team_status] = "All" if params[:team_status].blank?
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
          accounts = accounts.joins(student_profile: :parental_consent)
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

      if params[:type] == "Mentor"
        case params[:team_status]
        when "Needs BG check/Consent waiver"
          accounts = accounts.includes(:background_check, :consent_waiver)
            .references(:background_check, :consent_waivers)
            .where("background_checks.id IS NULL OR
                    consent_waivers.id IS NULL OR
                    consent_waivers.voided_at IS NOT NULL")
        when "On a team"
          accounts = accounts.where("mentor_profiles.id IN
            (SELECT DISTINCT(member_id) FROM memberships
                                        WHERE memberships.member_type = 'MentorProfile'
                                        AND memberships.joinable_type = 'Team'
                                        AND memberships.joinable_id IN

              (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

                (SELECT DISTINCT(registerable_id) FROM season_registrations
                                                  WHERE season_registrations.registerable_type = 'Team'
                                                  AND season_registrations.season_id = ?)))", Season.current.id)
        when "No team"
          accounts = accounts.where("mentor_profiles.id NOT IN
            (SELECT DISTINCT(member_id) FROM memberships
                                        WHERE memberships.member_type = 'MentorProfile'
                                        AND memberships.joinable_type = 'Team'
                                        AND memberships.joinable_id IN

              (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

                (SELECT DISTINCT(registerable_id) FROM season_registrations
                                                  WHERE season_registrations.registerable_type = 'Team'
                                                  AND season_registrations.season_id = ?)))", Season.current.id)
        end
      end

      accounts
    end
  end
end
