class AddLocaleToMediaConsents < ActiveRecord::Migration[7.0]
  def change
    add_column :media_consents, :locale, :string, default: "en"
  end
end
