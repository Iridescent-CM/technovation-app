class JobChannel < ApplicationCable::Channel
  def subscribed
    stream_from "job_#{params[:job_id]}"
  end
end
