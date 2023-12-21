module Seasoned
  extend ActiveSupport::Concern

  included do
    if name === "Certificate"
      include SeasonedByInteger
    else
      include SeasonedByArray
    end

    scope :current, -> {
      where(seasoning_scope(Season.current.year))
    }

    scope :past, -> {
      where.not(seasoning_scope(Season.current.year))
    }

    scope :by_season, ->(*years, **opts) {
      clauses = years.flatten.map do |year|
        seasoning_scope_as_string(year)
      end

      match = opts.fetch(:match) { "match_any" }.to_s

      if "match_all" == match
        where(clauses.join(" AND "))
      else
        where(clauses.join(" OR "))
      end
    }

    def current_season?
      seasons.include?(Season.current.year)
    end
  end

  module SeasonedByArray
    extend ActiveSupport::Concern

    def seasons
      self[:seasons].flatten.map(&:to_i).uniq.sort
    end

    module ClassMethods
      def seasoning_scope(year)
        "'#{year}' = ANY (#{table_name}.seasons)"
      end

      def seasoning_scope_as_string(year)
        seasoning_scope(year)
      end
    end
  end

  module SeasonedByInteger
    extend ActiveSupport::Concern

    def seasons
      [self[:season]]
    end

    module ClassMethods
      def seasoning_scope(year)
        {season: year}
      end

      def seasoning_scope_as_string(year)
        "#{table_name}.season = #{year.to_i}"
      end
    end
  end
end
