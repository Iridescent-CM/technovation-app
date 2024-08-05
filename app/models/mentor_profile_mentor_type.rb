class MentorProfileMentorType < ActiveRecord::Base
  belongs_to :mentor_profile
  belongs_to :mentor_type

  after_commit :update_mentor_info_in_crm

  private

  def update_mentor_info_in_crm
    CRM::UpdateProgramInfoJob.perform_later(
      account_id: mentor_profile.account.id,
      profile_type: "mentor"
    )
  end
end
