class Rubric
  class CreateToBrazil
    def self.run!(year:, regions:, country:)
      new(year, regions, country).run!
    end

    def initialize(year, regions, country)
      @year = year
      @regions = regions
      @country = country
    end
    
    def run!
      judges
      teams
    end

    private

    def teams
      Team.by_regions_year_and_country(@regions, @year, @country)
    end

    def judges
      User.judges_from(@country)
    end

  end
end
