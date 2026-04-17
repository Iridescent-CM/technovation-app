class CreateCommunityConnectionAvailabilitySlots < ActiveRecord::Migration[6.1]
  def change
    create_table :community_connection_availability_slots do |t|
      t.references :community_connection, foreign_key: {to_table: :community_connections}, index: {name: "index_ccas_on_cc_id"}
      t.references :availability_slot, foreign_key: {to_table: :availability_slots}, index: {name: "index_as_on_as_id"}

      t.timestamps
    end
  end
end
