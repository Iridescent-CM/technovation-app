require 'uri'

class ExportJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    Job.create!(job_id: job.job_id, status: "queued")
  end

  after_perform do |job|
    db_job = Job.find_by(job_id: job.job_id)
    db_job.update_column(:status, "complete")
  end

  def perform(
    user,
    grid_klass,
    params,
    context_name,
    scope_modifier,
    filename,
    format
  )
    filepath = "./tmp/#{filename.parameterize}.#{format}"

    context_klass = context_name.constantize

    grid = grid_klass.constantize.new(params) do |scope|
      context_klass.class_eval(scope_modifier).call(scope, user, params)
    end

    csv = grid.public_send("to_#{format}")

    File.open(filepath, "wb+") do |f|
      f.write(csv)
      f.close
    end

    user.exports.create!(file: File.open(filepath))
  end
end
