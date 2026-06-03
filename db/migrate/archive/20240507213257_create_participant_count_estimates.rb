class CreateParticipantCountEstimates < ActiveRecord::Migration[6.1]
  def change
    create_table :participant_count_estimates do |t|
      t.string :range
      t.integer :order

      t.timestamps
    end
  end
end
