module RegionalAmbassador
  class PossibleEventAttendeesController < RegionalAmbassadorController
    def index
      possible_attendees = PossibleEventAttendees.for(
        ambassador: current_ambassador,
        type: params.fetch(:type),
      )

      render json: possible_attendees
    end
  end

  class PossibleEventAttendees
    include Enumerable

    def self.for(ambassador:, type:)
      model = type.camelize.constantize
      records = model
        .live_event_eligible
        .in_region(ambassador)
        .order(:name)
      new(records)
    end

    def initialize(records)
      @records = records
    end

    def each(&block)
      @records.each do |record|
        block.call(PossibleEventAttendee.new(record))
      end
    end

    class PossibleEventAttendee
      attr_reader :record

      def initialize(record)
        @record = record
      end

      def as_json(*)
        base = {
          id: record.id,
          name: record.name,
        }

        if record.respond_to?(:submission)
          base.merge({
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
