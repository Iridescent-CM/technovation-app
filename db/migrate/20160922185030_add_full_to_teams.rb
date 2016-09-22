class AddFullToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :accepting_student_requests, :boolean, null: false, default: true
    add_column :teams, :accepting_mentor_requests, :boolean, null: false, default: true
  end
end
