class AddOwnersToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :owner, polymorphic: true
  end
end
