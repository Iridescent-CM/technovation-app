class AddSeasonsToParentalConsents < ActiveRecord::Migration[5.1]
  def change
    add_column :parental_consents, :seasons, :text, array: true, default: []
  end
end
