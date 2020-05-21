module Admin
  class SemifinalistSnippetController < AdminController
    def show
      senior_submissions_by_country = TeamSubmission
        .current
        .semifinalist
        .filter { |sub| sub.senior_division? }
        .group_by(&:country)
      @senior_columns = split_into_columns(senior_submissions_by_country)

      junior_submissions_by_country = TeamSubmission
        .current
        .semifinalist
        .filter { |sub| sub.junior_division? }
        .group_by(&:country)
      @junior_columns = split_into_columns(junior_submissions_by_country)

      render content_type: "text/plain", layout: false
    end

    private

    def entry_for(country, submissions)
      friendly_name = FriendlyCountry.(
        OpenStruct.new(address_details: country),
        prefix: false,
        source: :country_code,
      )

      {
        country: country,
        friendly_name: friendly_name,
        submissions: submissions.sort_by { |sub| sub.team_name.downcase }
      }
    end

    def split_into_columns(subs_by_country)
      left_col = []
      right_col = []

      total_subs = subs_by_country.values.reduce(0) { |sum, subs| sum + subs.count }
      subs_in_left_column = 0

      subs_by_country.sort.each do |country, submissions|
        if subs_in_left_column < (total_subs / 2)
          left_col << entry_for(country, submissions)
          subs_in_left_column = subs_in_left_column + submissions.count
        else
          right_col << entry_for(country, submissions)
        end
      end

      [left_col, right_col]
    end
  end
end
