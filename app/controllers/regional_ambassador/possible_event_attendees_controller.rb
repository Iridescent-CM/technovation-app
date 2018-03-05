module RegionalAmbassador
  class PossibleEventAttendeesController < RegionalAmbassadorController
    def index
      possible_attendees = PossibleEventAttendees.for(
        ambassador: current_ambassador,
        type: params.fetch(:type),
        context: self,
      )

      render json: possible_attendees
    end
  end

  class PossibleEventAttendees
    include Enumerable

    def self.for(ambassador:, type:, context:)
      model = type.camelize.constantize
      records = model
        .live_event_eligible
        .in_region(ambassador)
        .order(:name)
      new(records, context)
    end

    attr_reader :context

    def initialize(records, context)
      @records = records
      @context = context
    end

    def each(&block)
      @records.each do |record|
        block.call(PossibleEventAttendee.new(record, context))
      end
    end

    class PossibleEventAttendee
      attr_reader :record, :context

      def initialize(record, context)
        @record = record
        @context = context
      end

      def view_path
        "regional_ambassador_" +
        record.model_name.singular_route_key +
        "_path"
      end

      def as_json(*)
        base = {
          id: record.id,
          name: record.name,
          scope: record.class.name,
          links: {
            view: context.send(view_path, record)
          },
        }

        if record.respond_to?(:submission)
          base.merge({
            division: record.division_name,
            submission: {
              name: record.submission.app_name,
            },
          })
        else
          base
        end
      end
    end
  end
end
