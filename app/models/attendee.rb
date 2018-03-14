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
      links: {},
      status: record.status,
      human_status: record.human_status,
      status_explained: record.status_explained,
      selected: record.in_event?(event),
      assignments: { team_ids: [], judge_ids: [] },
    }

    if record.ambassador_route_key
      base[:links][:self] = context.send(
        "regional_ambassador_#{record.ambassador_route_key}_path",
        record,
        { allow_out_of_region: true },
      )
    end

    if record.respond_to?(:submission)
      base[:links] = base[:links].merge({
        submission: context.send(
          "regional_ambassador_team_submission_path",
          record.submission,
          { allow_out_of_region: true },
        ),
      })

      base[:assignments][:judge_ids] = record.judge_assignments
        .pluck(:assigned_judge_id)

      base.merge({
        division: record.division_name,
        submission: {
          name: record.submission.app_name,
        },
      })
    elsif record.respond_to?(:email)
      base[:assignments][:team_ids] = record.assigned_teams.pluck(:id)

      base.merge({
        email: record.email,
      })
    else
      base
    end
  end
end
