class AddJsonPayloadToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :payload, :json, default: {}
  end
end
