module Admin
  class SemifinalistSnippetController < AdminController
    layout false

    def show
      senior_submissions = TeamSubmission
        .current
        .semifinalist
        .select { |sub| sub.senior_division? }
      @senior_section = Section.new("senior", senior_submissions)

      junior_submissions = TeamSubmission
        .current
        .semifinalist
        .select { |sub| sub.junior_division? }
      @junior_section = Section.new("junior", junior_submissions)

      respond_to :html, :text
    end

    private

    class Section

      attr_reader :id, :columns, :toc

      def initialize(id, submissions)
        @id = id
        @columns = split_into_columns(submissions)
        @toc = build_toc(submissions)
      end

      def id_for(*parts)
        parts.prepend(id).map { |p| p.respond_to?(:downcase) ? p.downcase : p }.join("-")
      end

      private

      def split_into_columns(subs)
        left_col = []
        right_col = []

        total_subs = subs.count
        subs_in_left_column = 0

        entries = group_by_country(subs).map do |country_code, submissions|
          Entry.new(country_code, submissions)
        end

        entries.sort.each do |entry|
          if subs_in_left_column < (total_subs / 2)
            left_col << entry
            subs_in_left_column = subs_in_left_column + entry.submissions.count
          else
            right_col << entry
          end
        end

        [left_col, right_col]
      end

      def build_toc(subs)
        countries = group_by_country(subs).keys
        entries = countries.map do |country_code|
          Entry.new(country_code)
        end
        entries.sort
      end

      def group_by_country(submissions)
        submissions
          .group_by(&:country)
          .map { |k, v| [k.nil? ? '' : k, v] }
          .to_h
      end
    end

    class Entry

      attr_reader :friendly_name, :country_code, :submissions

      def initialize(country_code, submissions = [])
        @friendly_name = FriendlyCountry.(
          OpenStruct.new(address_details: country_code),
          prefix: false,
          source: :country_code,
        )
        @country_code = country_code
        @submissions = submissions.sort_by { |sub| sub.team_name.downcase }
      end

      def <=>(other)
        friendly_name <=> other.friendly_name
      end
    end
  end
end
