class AddNewsletterOptInToParentalConsents < ActiveRecord::Migration[4.2]
  def change
    add_column :parental_consents, :newsletter_opt_in, :boolean
  end
end
