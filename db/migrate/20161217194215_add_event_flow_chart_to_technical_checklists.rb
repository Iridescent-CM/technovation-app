class AddEventFlowChartToTechnicalChecklists < ActiveRecord::Migration[4.2]
  def change
    add_column :technical_checklists, :event_flow_chart, :string
  end
end
