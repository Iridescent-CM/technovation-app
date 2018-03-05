class Attendees
  include Enumerable

  def self.for(ambassador: nil, type:, context:, event: nil)
    if ambassador
      model = type.to_s.camelize.constantize
      records = model
        .live_event_eligible
        .in_region(ambassador)
        .order(:name)
    else
      assoc = type.to_s.underscore.downcase.pluralize
      records = event.send(assoc)
    end

    new(records, context)
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
