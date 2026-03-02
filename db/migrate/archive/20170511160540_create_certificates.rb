class CreateCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :certificates do |t|
      t.references :account, foreign_key: true
      t.string :file

      t.timestamps
    end
  end
end
