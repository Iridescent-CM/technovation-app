module Seasoned
  extend ActiveSupport::Concern

  included do
    scope :current, -> {
      where("'#{Season.current.year}' = ANY (#{table_name}.seasons)")
    }

    scope :past, -> {
      where.not("'#{Season.current.year}' = ANY (#{table_name}.seasons)")
    }

    scope :by_season, ->(*years) {
      clauses = years.flatten.map do |year|
        "'#{year}' = ANY (#{table_name}.seasons)"
      end

      where(clauses.join(' OR '))
    }

    def seasons
      self[:seasons].flatten.map(&:to_i).uniq
    end
  end
end
