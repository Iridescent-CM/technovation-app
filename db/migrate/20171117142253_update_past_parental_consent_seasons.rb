class UpdatePastParentalConsentSeasons < ActiveRecord::Migration[5.1]
  def up
    ParentalConsent.where(voided_at: nil).update_all(
      seasons: [Season.current.year]
    )

    ParentalConsent.where.not(voided_at: nil).update_all(
      seasons: [Season.current.year - 1]
    )
  end

  def down
    ParentalConsent.past.update_all(voided_at: Date.new(2017, 9, 30))
  end
end
