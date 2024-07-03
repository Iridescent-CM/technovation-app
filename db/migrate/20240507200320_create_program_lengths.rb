class CreateProgramLengths < ActiveRecord::Migration[6.1]
  def change
    create_table :program_lengths do |t|
      t.string :length

      t.timestamps
    end
  end
end
