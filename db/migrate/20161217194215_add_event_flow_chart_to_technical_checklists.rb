class AddEventFlowChartToTechnicalChecklists < ActiveRecord::Migration
  def change
    add_column :technical_checklists, :event_flow_chart, :string
  end
end
