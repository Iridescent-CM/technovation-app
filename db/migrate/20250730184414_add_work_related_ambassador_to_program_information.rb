class AddWorkRelatedAmbassadorToProgramInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :program_information, :work_related_ambassador, :boolean, null: true
  end
end
