class Attendee
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
        self: context.send(
          view_path,
          record,
          { allow_out_of_region: true },
        ),
      },
      status: record.status,
      human_status: record.human_status,
      status_explained: record.status_explained,
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
    else
      base
    end
  end
end
