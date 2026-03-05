class AddLocaleToParentalConsents < ActiveRecord::Migration[7.0]
  def change
    add_column :parental_consents, :locale, :string, default: "en"
  end
end
