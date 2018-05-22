module Seasoned
  extend ActiveSupport::Concern

  included do
    if column_names.include?("seasons")
      include SeasonedByArray
    elsif column_names.include?("season")
      include SeasonedByInteger
    else
      raise "Supported Database field not found - " +
            "Please add seasons:array or season:integer to " +
            table_name
    end

    scope :current, -> { where(seasoning_scope(Season.current.year)) }
    scope :past,  -> { where.not(seasoning_scope(Season.current.year)) }
    scope :by_season, ->(*args) { by_season_scope(*args) }

    def current_season?
      seasons.include?(Season.current.year)
    end

    module ClassMethods
      def by_season_scope(*args)
        years = args.select { |a| not a.is_a?(Hash) }.flatten
        opts = args.select { |a| a.is_a?(Hash) }[0] ||
                { match: "match_any" }

        clauses = years.flatten.map do |year|
          seasoning_scope_as_string(year)
        end

        if "match_all" == opts[:match].to_s
          where(clauses.join(' AND '))
        else
          where(clauses.join(' OR '))
        end
      end
    end
  end

  module SeasonedByArray
    extend ActiveSupport::Concern

    def seasons
      self[:seasons].flatten.map(&:to_i).uniq
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
        { season: year }
      end

      def seasoning_scope_as_string(year)
        "#{table_name}.season = #{year.to_i}"
      end
    end
  end
end