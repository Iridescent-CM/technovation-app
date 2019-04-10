class Attendee
  extend Forwardable

  attr_reader :record, :event, :context

  def initialize(record, event, context)
    @record = record
    @event = event
    @context = context
  end

  def id
    record.id_for_event
  end

  def scope
    record.event_scope
  end

  def_delegators :@record, :name, :status, :human_status, :status_explained

  def selected
    record.in_event?(event)
  end

  def links
    base_links = {}

    if record.ambassador_route_key
      base_links[:self] = context.send(
        "regional_ambassador_#{record.ambassador_route_key}_path",
        record,
        { allow_out_of_region: true },
      )
    end

    if record.respond_to?(:submission)
      base_links = base_links.merge({
        submission: context.send(
          "regional_ambassador_team_submission_path",
          record.submission,
          { allow_out_of_region: true },
        ),
      })
    end

    base_links
  end


  def division
    if record.respond_to?(:division_name)
      record.division_name
    end
  end

  def submission
    if record.respond_to?(:submission)
      {
        name: record.submission.app_name,
      }
    end
  end

  def assignments
    team_ids = []
    judge_ids = []

    if record.respond_to?(:judge_assignments)
      judge_ids = record.judge_assignments.pluck(:assigned_judge_id)
    elsif record.respond_to?(:assigned_teams)
      team_ids = record.assigned_teams.pluck(:id)
    end

    {
      team_ids: team_ids,
      judge_ids: judge_ids,
    }
  end

  def email
    if record.respond_to?(:email)
      record.email
    end
  end

  def persisted?
    record.persisted?
  end
end