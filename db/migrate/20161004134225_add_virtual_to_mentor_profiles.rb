class AddVirtualToMentorProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :mentor_profiles, :virtual, :boolean, null: false, default: true
    add_index :mentor_profiles, :virtual
  end
end
