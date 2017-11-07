class JobChannel < ApplicationCable::Channel
  def subscribed
    stream_from "jobs:#{params[:current_account_id]}"
  end
end
