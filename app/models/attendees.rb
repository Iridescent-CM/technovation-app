class Attendees
  include Enumerable

  def self.for(
    type:,
    context:,
    query: "",
    expand_search: false,
    ambassador: NullRegionalAmbassador.new,
    event: NullEvent.new
  )
    model = type.to_s.camelize.constantize
    table_name = model.table_name
    sort_column = model.sort_column

    if ambassador.present?
      scope = model.live_event_eligible(event)

      if expand_search
        records = scope.by_query(query)
      else
        records = scope.in_region(ambassador)
      end
    else
      assoc = type.to_s.underscore.downcase.pluralize
      records = event.send(assoc)
    end

    if records.is_a?(Array)
      new(records.sort_by(&sort_column), context)
    else
      new(records.order("#{table_name}.#{sort_column}"), context)
    end
  end

  attr_reader :context

  def initialize(records, context)
    @records = records
    @context = context
  end

  def each(&block)
    @records.each do |record|
      block.call(Attendee.new(record, context))
    end
  end
end
