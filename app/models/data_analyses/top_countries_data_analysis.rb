module DataAnalyses
  class TopCountriesDataAnalysis < DataAnalysis
    def init_data
      @top_countries = Account.current
        .where("country IS NOT NULL")
        .group(:country)
        .limit(10)
        .order("count_all desc")
        .count

      @top_students = Account.current
        .left_outer_joins(:student_profile)
        .where("student_profiles.id IS NOT NULL")
        .where(country: @top_countries.keys)
        .group(:country)
        .order("country desc")
        .count

      @top_mentors = Account.current
        .left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
        .where(country: @top_countries.keys)
        .group(:country)
        .order("country desc")
        .count

      @top_judges = Account.current
        .left_outer_joins(:judge_profile)
        .where("judge_profiles.id IS NOT NULL")
        .where(country: @top_countries.keys)
        .group(:country)
        .order("country desc")
        .count

      @top_countries.each { |key, value| @top_countries[key] = 0 }

      @top_students = @top_countries.merge(@top_students)
      @top_mentors = @top_countries.merge(@top_mentors)
      @top_judges = @top_countries.merge(@top_judges)
    end

    def totals
      {
        top_countries: number_with_delimiter(
          @top_students.values.sum +
          @top_mentors.values.sum +
          @top_judges.values.sum
        )
      }
    end

    def labels
      @top_countries.keys.map do |country_code|
        FriendlyCountry.call(OpenStruct.new(address_details: country_code), prefix: false,
          source: :country_code)
      end
    end

    def datasets
      [
        {
          label: "Students",
          data: @top_students.values
        },
        {
          label: "Mentors",
          data: @top_mentors.values
        },
        {
          label: "Judges",
          data: @top_judges.values
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
              country: [country_code]
            }
          )
        },

        @top_mentors.keys.map { |country_code|
          url_helper.public_send(
            "#{user.scope_name}_participants_path",
            accounts_grid: {
              scope_names: ["mentor"],
              country: [country_code]
            }
          )
        },

        @top_judges.keys.map { |country_code|
          url_helper.public_send(
            "#{user.scope_name}_participants_path",
            accounts_grid: {
              scope_names: ["judge"],
              country: [country_code]
            }
          )
        }
      ]
    end
  end
end
