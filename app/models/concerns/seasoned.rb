module Seasoned
  extend ActiveSupport::Concern

  included do
    scope :current, -> {
      where("'#{Season.current.year}' = ANY (#{table_name}.seasons)")
    }

    scope :past, -> {
      where.not("'#{Season.current.year}' = ANY (#{table_name}.seasons)")
    }

    scope :by_season, ->(year) {
      where("'#{year}' = ANY (#{table_name}.seasons)")
    }

    def seasons
      self[:seasons].map(&:to_i)
    end
  end
end
