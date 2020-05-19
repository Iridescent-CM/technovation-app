module Admin
  class SemifinalistSnippetController < AdminController
    def show
      senior_submissions = TeamSubmission.current.semifinalist.filter { |sub| sub.senior_division? }
      senior_submissions_by_country = senior_submissions.group_by(&:country)
      @senior_columns = split_columns(senior_submissions_by_country)

      junior_submissions = TeamSubmission.current.semifinalist.filter { |sub| sub.junior_division? }
      junior_submissions_by_country = junior_submissions.group_by(&:country)
      @junior_columns = split_columns(junior_submissions_by_country)

      render content_type: "text/plain", layout: false
    end

    private

    def split_columns(submissions_by_country)
      left_col = []
      right_col = []

      overall_count = submissions_by_country.values.reduce(0) { |sum, subs| sum + subs.count }
      running_count = 0

      submissions_by_country.each do |country_name, submissions|
        if running_count < (overall_count / 2)
          running_count = running_count + submissions.count
          left_col << { country: country_name, submissions: submissions }
        else
          right_col << { country: country_name, submissions: submissions }
        end
      end

      [left_col, right_col]
    end
  end
end
