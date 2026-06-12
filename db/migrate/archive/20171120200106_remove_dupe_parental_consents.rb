class RemoveDupeParentalConsents < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.transaction do
      ids = ParentalConsent.nonvoid.group_by(&:student_profile_id)

      keep = ids.flat_map { |_, consents| consents.first }.map(&:id)

      throwout = ids.flat_map { |_, consents| consents.map(&:id) }
        .reject { |id| keep.include?(id) }

      ParentalConsent.nonvoid.where(id: throwout).destroy_all
    end
  end
end
