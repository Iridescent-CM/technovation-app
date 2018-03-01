module Regioned
  extend ActiveSupport::Concern

  included do
    scope :in_region, ->(ambassador) {
      results = scope_records(ambassador)

      SecondaryRegions.new(ambassador).each do |region|
        results += scope_records(region)
      end

      results
    }
  end

  module ClassMethods
    def scope_records(source)
      scope = if regioned_through_assoc
                includes(region_source)
                  .references(region_source_table)
              else
                self
              end

      if source.country == "US"
        scope.where("#{region_source_table}.country = ? AND " +
                    "#{region_source_table}.state_province = ?",
                    source.country,
                    source.state_province)
      else
        scope.where(
          "#{region_source_table}.country = ?",
          source.country
        )
      end
    end

    def region_source
      model_name.element
    end

    def region_source_table
      table_name
    end

    def regioned_through_assoc
      false
    end

    def regioned_source(klass, opts = {})
      define_singleton_method :regioned_through_assoc do
        true
      end

      define_singleton_method :region_source do
        if opts[:through]
          { opts[:through] => klass.model_name.element }
        else
          klass.model_name.element
        end
      end

      define_singleton_method :region_source_table do
        klass.table_name
      end
    end
  end

  class SecondaryRegions
    include Enumerable

    def initialize(ambassador)
      @regions = ambassador.secondary_regions
    end

    def each(&block)
      @regions.each do |ambassador_region|
        region = SecondaryRegion.new(ambassador_region)
        block.call(region)
      end
    end

    class SecondaryRegion
      attr_reader :state, :country
      alias :state_province :state

      def initialize(region)
        @state = region.split(", ").first
        @country = region.split(", ").last
      end
    end
  end
end
