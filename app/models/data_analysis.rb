class DataAnalysis
  include ActionView::Helpers::NumberHelper

  attr_reader :user

  def self.for(user, analysis_type)
    if analysis_type.to_s == "onboarding_mentors" && !user.is_admin? && user.country != "US"
      OnboardingInternationalMentorsDataAnalysis.new(user)
    else
      "#{analysis_type.to_s.camelize}DataAnalysis".constantize.new(user)
    end
  end

  def initialize(user)
    @user = user
    init_data
  end

  def id
    Time.current.to_i
  end

  def data
    []
  end

  def datasets
    []
  end

  def totals
    {}
  end

  def urls
    []
  end

  private
  def show_percentage(num_collection, denom_collection)
    "(" +
      number_to_percentage(
        get_percentage(num_collection, denom_collection),
        precision: 0
      ) +
    ")"
  end

  def get_percentage(num_collection, denom_collection, passed_opts = {})
    return 0 if denom_collection.count.zero?

    options = {
      round: 0,
    }.merge(passed_opts)

    ((num_collection.count / denom_collection.count.to_f) * 100)
      .round(options[:round])
  end

  def url_helper
    Rails.application.routes.url_helpers
  end
end

class PermittedStudentsDataAnalysis < DataAnalysis
  def init_data
    if user.is_admin?
      @students = StudentProfile.current
    else
      @students = StudentProfile.current.in_region(user)
    end

    @permitted_students = @students.joins(:signed_parental_consent)
    @unpermitted_students = @students.joins(:pending_parental_consent)
  end

  def totals
    {
      students: number_with_delimiter(@students.count),
    }
  end

  def labels
    [
      "With parental permission – #{show_percentage(@permitted_students, @students)}",
      "Without parental permission – #{show_percentage(@unpermitted_students, @students)}",
    ]
  end

  def data
    [
      @permitted_students.count,
      @unpermitted_students.count,
    ]
  end

  def urls
    [
      url_helper.public_send("#{user.scope_name}_participants_path",
        accounts_grid: {
          scope_names: ["student"],
          parental_consent: "parental_consented",
        }
      ),

      url_helper.public_send("#{user.scope_name}_participants_path",
        accounts_grid: {
          scope_names: ["student"],
          parental_consent: "not_parental_consented",
        }
      ),
    ]
  end
end

class ReturningStudentsDataAnalysis < DataAnalysis
  def init_data
    if user.is_admin?
      @students = StudentProfile.current
    else
      @students = StudentProfile.current.in_region(user)
    end

    @new_students = @students.where("array_length(accounts.seasons, 1) = 1")
    @returning_students = @students.where("array_length(accounts.seasons, 1) > 1")
  end

  def totals
    {
      students: number_with_delimiter(@students.count),
    }
  end

  def labels
    [
      "Returning students – #{show_percentage(@returning_students, @students)}",
      "New students – #{show_percentage(@new_students, @students)}",
    ]
  end

  def data
    [
      @returning_students.count,
      @new_students.count,
    ]
  end
end

class OnboardingMentorsDataAnalysis < DataAnalysis
  def init_data
    if user.is_admin?
      @mentors = Account.current
        .left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
    else
      @mentors = Account.current
        .left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
        .in_region(user)
    end

    @cleared_mentors = @mentors.bg_check_clear.consent_signed
    @signed_consent_mentors = @mentors.bg_check_submitted.consent_signed
    @cleared_bg_check_mentors = @mentors.bg_check_clear.consent_not_signed
    @neither_mentors = @mentors.bg_check_unsubmitted.consent_not_signed
  end

  def totals
    {
      mentors: number_with_delimiter(@mentors.count),
    }
  end

  def labels
    [
      "Signed consent & cleared a background check, if required – #{show_percentage(@cleared_mentors, @mentors)}",
      "Only signed consent – #{show_percentage(@signed_consent_mentors, @mentors)}",
      "Only cleared bg check, if required – #{show_percentage(@cleared_bg_check_mentors, @mentors)}",
      "Have done neither – #{show_percentage(@neither_mentors, @mentors)}",
    ]
  end

  def data
    [
      @cleared_mentors.count,
      @signed_consent_mentors.count,
      @cleared_bg_check_mentors.count,
      @neither_mentors.count,
    ]
  end

  def urls
    [
      url_helper.public_send("#{user.scope_name}_participants_path",
        accounts_grid: {
          scope_names: ["mentor"],
          background_check: "bg_check_clear",
          consent_waiver: "consent_signed",
        }
      ),

      url_helper.public_send("#{user.scope_name}_participants_path",
        accounts_grid: {
          scope_names: ["mentor"],
          background_check: "bg_check_submitted",
          consent_waiver: "consent_signed",
        }
      ),

      url_helper.public_send("#{user.scope_name}_participants_path",
        accounts_grid: {
          scope_names: ["mentor"],
          background_check: "bg_check_clear",
          consent_waiver: "consent_not_signed",
        }
      ),

      url_helper.public_send("#{user.scope_name}_participants_path",
        accounts_grid: {
          scope_names: ["mentor"],
          background_check: "bg_check_unsubmitted",
          consent_waiver: "consent_not_signed",
        }
      ),
    ]
  end
end

class OnboardingInternationalMentorsDataAnalysis < DataAnalysis
  def init_data
    @mentors = Account.current
      .left_outer_joins(:mentor_profile)
      .where("mentor_profiles.id IS NOT NULL")
      .in_region(user)

    @consenting_mentors = @mentors.eager_load(:consent_waiver)
        .where("consent_waivers.id IS NOT NULL")

    @unconsenting_mentors = @mentors.eager_load(:consent_waiver)
      .where("consent_waivers.id IS NULL")
  end

  def totals
    {
      mentors: number_with_delimiter(@mentors.count),
    }
  end

  def labels
    [
      "Signed consent – #{show_percentage(@consenting_mentors, @mentors)}",
      "Has not signed – #{show_percentage(@unconsenting_mentors, @mentors)}",
    ]
  end

  def data
    [
      @consenting_mentors.count,
      @unconsenting_mentors.count,
    ]
  end

  def urls
    [
      url_helper.regional_ambassador_participants_path(
        accounts_grid: {
          scope_names: ["mentor"],
          consent_waiver: "consent_signed",
        }
      ),

      url_helper.regional_ambassador_participants_path(
        accounts_grid: {
          scope_names: ["mentor"],
          consent_waiver: "consent_not_signed",
        }
      ),
    ]
  end
end

class ReturningMentorsDataAnalysis < DataAnalysis
  def init_data
    if user.is_admin?
      @mentors = Account.current.left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
    else
      @mentors = Account.current.left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
        .in_region(user)
    end

    @new_mentors = @mentors.where('array_length(accounts.seasons, 1) = 1')
    @returning_mentors = @mentors.where('array_length(accounts.seasons, 1) > 1')
  end

  def totals
    {
      mentors: number_with_delimiter(@mentors.count),
    }
  end

  def labels
    [
      "Returning mentors – #{show_percentage(@returning_mentors, @mentors)}",
      "New mentors – #{show_percentage(@new_mentors, @mentors)}",
    ]
  end

  def data
    [
      @returning_mentors.count,
      @new_mentors.count,
    ]
  end
end

class TopCountriesDataAnalysis < DataAnalysis
  def init_data
    @top_countries = Account.current
      .where("country IS NOT NULL")
      .group(:country)
      .limit(10)
      .order('count_all desc')
      .count

    @top_students = Account.current
      .left_outer_joins(:student_profile)
      .where("student_profiles.id IS NOT NULL")
      .where(country: @top_countries.keys)
      .group(:country)
      .order('country desc')
      .count

    @top_mentors = Account.current
      .left_outer_joins(:mentor_profile)
      .where("mentor_profiles.id IS NOT NULL")
      .where(country: @top_countries.keys)
      .group(:country)
      .order('country desc')
      .count

    @top_judges = Account.current
      .left_outer_joins(:judge_profile)
      .where("judge_profiles.id IS NOT NULL")
      .where(country: @top_countries.keys)
      .group(:country)
      .order('country desc')
      .count

    @top_countries.each {|key, value| @top_countries[key] = 0 }

    @top_students = @top_countries.merge(@top_students)
    @top_mentors = @top_countries.merge(@top_mentors)
    @top_judges = @top_countries.merge(@top_judges)
  end

  def totals
    {
      top_countries: number_with_delimiter(
        @top_students.values.sum +
        @top_mentors.values.sum +
        @top_judges.values.sum),
    }
  end

  def labels
    @top_students.keys.map do |country_code|
      FriendlyCountry.(
        OpenStruct.new(country: country_code),
        prefix: false,
      )
    end
  end

  def datasets
    [
      {
        label: 'Students',
        data: @top_students.values,
      },
      {
        label: 'Mentors',
        data: @top_mentors.values,
      },
      {
        label: 'Judges',
        data: @top_judges.values,
      }
    ]
  end

  def urls
    [
      @top_students.keys.map { |country_code|
        url_helper.public_send(
          "#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["student"],
            country: [country_code],
          }
        )
      },

      @top_mentors.keys.map { |country_code|
        url_helper.public_send(
          "#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            country: [country_code],
          }
        )
      },

      @top_judges.keys.map { |country_code|
        url_helper.public_send(
          "#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["judge"],
            country: [country_code],
          }
        )
      },
    ]
  end
end