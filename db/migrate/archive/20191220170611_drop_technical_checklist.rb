class DropTechnicalChecklist < ActiveRecord::Migration[5.1]
  def change
    if table_exists?(:technical_checklists)
      drop_table :technical_checklists
    end
  end
end
