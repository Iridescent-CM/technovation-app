module Regioned
  extend ActiveSupport::Concern

  included do
    scope :in_region, ->(ambassador) {
      regioned_scope = if regioned_through_assoc
        includes(region_source)
          .references(region_source_table)
      else
        self
      end

      regioned_scope.where(
        primary_query(ambassador) +
        seconday_query(ambassador)
      )
    }
  end

  module ClassMethods
    def primary_query(ambassador)
      construct_query(ambassador)
    end

    def seconday_query(ambassador)
      regions = SecondaryRegions.new(ambassador)

      if regions.any?
        " OR " +
          regions.map { |region|
            construct_query(region)
          }.join(" OR ")
      else
        ""
      end
    end

    def construct_query(source)
      if source.country_code == "US"
        "(#{region_source_table}.country = 'US' AND " +
          "#{region_source_table}.state_province " +
          "= '#{source.state_code}')"
      else
        "(#{region_source_table}.country = '#{source.country_code}')"
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
          {opts[:through] => klass.model_name.element}
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
      attr_reader :state_code, :country_code
      alias_method :state_province, :state_code

      def initialize(region)
        @state_code = region.split(", ").first
        @country_code = region.split(", ").last
      end
    end
  end
end
