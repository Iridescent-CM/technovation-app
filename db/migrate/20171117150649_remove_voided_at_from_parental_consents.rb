class RemoveVoidedAtFromParentalConsents < ActiveRecord::Migration[5.1]
  def change
    remove_column :parental_consents, :voided_at, :datetime
  end
end
