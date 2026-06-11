class ResetExportsAndJobs < ActiveRecord::Migration[5.1]
  def up
    Job.delete_all
    Export.delete_all
  end
end
