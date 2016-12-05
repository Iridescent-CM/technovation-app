class AddNewsletterOptInToParentalConsents < ActiveRecord::Migration
  def change
    add_column :parental_consents, :newsletter_opt_in, :boolean
  end
end
