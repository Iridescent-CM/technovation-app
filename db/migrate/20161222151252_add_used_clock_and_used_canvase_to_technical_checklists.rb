class AddUsedClockAndUsedCanvaseToTechnicalChecklists < ActiveRecord::Migration
  def change
    add_column :technical_checklists, :used_clock, :boolean
    add_column :technical_checklists, :used_clock_explanation, :string
    add_column :technical_checklists, :used_canvas, :boolean
    add_column :technical_checklists, :used_canvas_explanation, :string
  end
end
