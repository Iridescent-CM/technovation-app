module Seasoned
  extend ActiveSupport::Concern

  included do
    scope :current, -> {
      where("'#{Season.current.year}' = ANY (#{table_name}.seasons)")
    }

    scope :past, -> {
      where.not("'#{Season.current.year}' = ANY (#{table_name}.seasons)")
    }

    scope :by_season, ->(*args) {
      years = args.select { |a| not a.is_a?(Hash) }.flatten
      opts = args.select { |a| a.is_a?(Hash) }[0] ||
               { match: "match_any" }

      clauses = years.flatten.map do |year|
        "'#{year}' = ANY (#{table_name}.seasons)"
      end

      if "match_all" == opts[:match].to_s
        where(clauses.join(' AND '))
      else
        where(clauses.join(' OR '))
      end
    }

    def seasons
      self[:seasons].flatten.map(&:to_i).uniq
    end
  end
end
