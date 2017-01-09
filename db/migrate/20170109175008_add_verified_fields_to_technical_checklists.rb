class AddVerifiedFieldsToTechnicalChecklists < ActiveRecord::Migration
  def change
    add_column :technical_checklists, :paper_prototype_verified, :boolean
    add_column :technical_checklists, :event_flow_chart_verified, :boolean
    add_column :technical_checklists, :used_clock_verified, :boolean
    add_column :technical_checklists, :used_canvas_verified, :boolean
  end
end
