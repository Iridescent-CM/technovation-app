class UpdateParentalConsents < ActiveRecord::Migration[5.1]
  class StudentProfile < ActiveRecord::Base
    belongs_to :account

    belongs_to :current_account, -> { current },
      foreign_key: :account_id,
      class_name: "Account",
      required: false

    has_many :parental_consents, dependent: :destroy
  end

  def up
    consented_count = StudentProfile.joins(:current_account).left_outer_joins(:parental_consents).where("parental_consents.id IS NOT NULL").count
    unconsented_count = StudentProfile.joins(:current_account).left_outer_joins(:parental_consents).where("parental_consents.id IS NULL").count
    total = StudentProfile.joins(:current_account).count

    ActiveRecord::Base.transaction do
      ParentalConsent.update_all(status: ParentalConsent.statuses[:signed])

      StudentProfile.find_each do |student|
        student.seasons.each do |season|
          student.parental_consents.create!({
            status: :pending,
            seasons: Array(season),
          }) if student.parental_consents.by_season(season).empty?
        end
      end

      consented_count2 = StudentProfile.joins(:current_account).left_outer_joins(:parental_consents).where("parental_consents.id IS NOT NULL").count
      unconsented_count2 = StudentProfile.joins(:current_account).left_outer_joins(:parental_consents).where("parental_consents.id IS NULL").count
      total2 = StudentProfile.joins(:current_account).count

      if consented_count2 != consented_count and
          unconsented_count2 != unconsented_count and
            total != total2
        raise "Counts are wrong"
      end
    end
  end

  def down
    ParentalConsent.pending.destroy_all
  end
end
