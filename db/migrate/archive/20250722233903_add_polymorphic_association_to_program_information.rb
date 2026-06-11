class AddPolymorphicAssociationToProgramInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :program_information, :chapterable_type, :string
    add_column :program_information, :chapterable_id, :integer

    add_index :program_information, [:chapterable_type, :chapterable_id], name: "index_program_information_on_chapterable"
  end
end
