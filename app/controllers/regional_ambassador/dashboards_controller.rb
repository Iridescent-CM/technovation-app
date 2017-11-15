module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      if current_ambassador.needs_intro_prompt?
        current_ambassador.regional_links.build
      else
        trackable_user_ids = Account.current
          .not_staff
          .in_region(current_ambassador)
          .pluck(:id) - [current_ambassador.account_id]

        trackable_team_ids = Team.current
          .in_region(current_ambassador)
          .pluck(:id)

        user_activities = PublicActivity::Activity.where(
          trackable_id: trackable_user_ids,
          trackable_type: "Account"
        )
         .order("created_at desc")
         .first(7)

        team_activities = PublicActivity::Activity.where(
          trackable_id: trackable_team_ids,
          trackable_type: "Team"
        )
         .order("created_at desc")
         .first(7)

        @activities = (user_activities + team_activities).sort do |a, b|
          b.created_at <=> a.created_at
        end

        inactive_mentors = Account.current
          .not_staff
          .in_region(current_ambassador)
          .joins(:mentor_profile)
          .left_outer_joins(:activities)
          .where("activities.id IS NULL")
          .first(10)

        if inactive_mentors.empty?
          inactive_mentors = Account.current
            .not_staff
            .joins(:mentor_profile)
            .in_region(current_ambassador)
            .order("last_logged_in_at asc")
            .first(10)
        end

        @top_inactive = inactive_mentors.sort_by(&:updated_at)

        @students = StudentProfile.current.in_region(current_ambassador)

        @mentors = Account.current.in_region(current_ambassador)
          .left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")

        if current_ambassador.country == "US"
          init_us_mentor_data
        else
          init_intl_mentor_data
        end

        @permitted_students = @students.joins(:parental_consent)
        @unpermitted_students = @students.left_outer_joins(:parental_consent)
          .where("parental_consents.id IS NULL")

        @new_students = @students.where(
          "accounts.created_at > ?",
          Date.new(Season.current.year - 1, 10, 18)
        )

        @returning_students = @students.where(
          "accounts.created_at < ?",
          Date.new(Season.current.year - 1, 10, 18)
        )

        @new_mentors = @mentors.where(
          "accounts.created_at > ?",
          Date.new(Season.current.year - 1, 10, 18)
        )

        @returning_mentors = @mentors.where(
          "accounts.created_at < ?",
          Date.new(Season.current.year - 1, 10, 18)
        )
      end

      @uploader = ImageUploader.new
      @uploader.success_action_redirect =
        regional_ambassador_profile_image_upload_confirmation_url(
          back: regional_ambassador_dashboard_path
        )
      render "regional_ambassador/dashboards/show_#{current_ambassador.status}"
    end

    private
    def init_intl_mentor_data
      @consenting_mentors = @mentors.eager_load(:consent_waiver)
        .where("consent_waivers.id IS NOT NULL")

      @unconsenting_mentors = @mentors.eager_load(:consent_waiver)
        .where("consent_waivers.id IS NULL")
    end

    def init_us_mentor_data
      @cleared_mentors = @mentors.bg_check_clear.consent_signed

      @signed_consent_mentors = @mentors.bg_check_submitted.consent_signed

      @cleared_bg_check_mentors = @mentors.bg_check_clear.consent_not_signed

      @neither_mentors = @mentors.bg_check_unsubmitted.consent_not_signed
    end
  end
end
