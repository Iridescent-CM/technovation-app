class JobChannel < ApplicationCable::Channel
  include Rails.application.routes.url_helpers

  def subscribed
    stream_from(
      "jobs:#{params[:current_profile_type]}:#{params[:current_profile_id]}"
    )

    if job = Job.owned_by(current_profile).queued.first
      ActionCable.server.broadcast(
        "jobs:#{params[:current_profile_type]}:#{params[:current_profile_id]}",
        {
          status: job.status,
          job_id: job.job_id
        }
      )
    elsif export = Export.owned_by(current_profile).undownloaded.last
      ActionCable.server.broadcast(
        "jobs:#{params[:current_profile_type]}:#{params[:current_profile_id]}",
        {
          status: "complete",
          job_id: export.job_id,
          filename: export["file"],
          url: export.file_url,
          update_url: send(
            "#{current_user.scope_name}_export_download_path",
            export
          )
        }
      )
    end
  end
end
