require "uri"

class ExportJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  queue_as :default

  before_enqueue do |job|
    profile_id = job.arguments[0]
    profile_type = job.arguments[1]

    profile = profile_type.constantize.find(profile_id)

    db_job = Job.create!(
      owner: profile,
      job_id: job.job_id,
      status: "queued"
    )

    broadcast(db_job, profile)
  end

  after_perform do |job|
    db_job = Job.find_by(job_id: job.job_id)
    db_job.update_column(:status, "complete")

    profile_id = job.arguments[0]
    profile_type = job.arguments[1]
    profile = profile_type.constantize.find(profile_id)

    broadcast(db_job, profile)
  end

  def perform(
    profile_id,
    profile_type,
    grid_klass,
    params,
    context_name,
    scope_modifier,
    filename,
    format
  )
    filepath = "./tmp/#{filename.parameterize}.#{format}"

    context_klass = context_name.constantize

    params.each do |k, v|
      params[k] = if v.is_a?(Array)
        v.reject(&:blank?)
      else
        v
      end
    end

    profile = profile_type.constantize.find(profile_id)

    grid = grid_klass.constantize.new(params) do |scope|
      context_klass.class_eval(scope_modifier)
        .call(scope, profile, params)
    end

    csv = grid.public_send("to_#{format}")

    File.open(filepath, "wb+") do |f|
      f.write(csv)
      f.close
    end

    profile.exports.create!(
      file: File.open(filepath),
      job_id: job_id
    )
  end

  private

  def broadcast(job, profile)
    channel = "jobs:#{profile.class.name}:#{profile.id}"
    data = {
      status: job.status,
      job_id: job.job_id
    }

    if job.status == "complete"
      export = profile.exports.find_by(job_id: job.job_id)

      data.merge!({
        filename: export["file"],
        url: export.file_url,
        update_url: send(
          "#{profile.account.scope_name}_export_download_path",
          export
        )
      })
    end

    ActionCable.server.broadcast(channel, data)
  end
end
