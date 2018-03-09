class Attendee
  attr_reader :record, :event, :context

  def initialize(record, event, context)
    @record = record
    @event = event
    @context = context
  end

  def as_json(*)
    base = {
      id: record.id_for_event,
      name: record.name,
      scope: record.event_scope,
      links: {
        self: context.send(
          "regional_ambassador_#{record.ambassador_route_key}_path",
          record,
          { allow_out_of_region: true },
        ),
      },
      status: record.status,
      human_status: record.human_status,
      status_explained: record.status_explained,
      selected: record.in_event?(event),
    }

    if record.respond_to?(:submission)
      base[:links] = base[:links].merge({
        submission: context.send(
          "regional_ambassador_team_submission_path",
          record.submission,
          { allow_out_of_region: true },
        ),
      })

      base.merge({
        division: record.division_name,
        submission: {
          name: record.submission.app_name,
        },
      })
    elsif record.respond_to?(:email)
      base.merge({
        email: record.email,
      })
    else
      base
    end
  end
end
