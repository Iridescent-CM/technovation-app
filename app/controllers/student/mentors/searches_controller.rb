module Student
  module Mentors
    class SearchesController < StudentController
      def show
        @filter = Filter.new(params.fetch(:filter) { {} })
        @expertises = Expertise.all
        @mentors = SearchMentors.(@filter)
      end

      class Filter < Struct.new(:filter_options)
        def fetch(key, &block)
          filter_options.fetch(key, &block)
        end

        def expertise_ids
          filter_options.fetch(:expertise_ids) { [] }.reject(&:blank?).map(&:to_i)
        end
      end
    end
  end
end
