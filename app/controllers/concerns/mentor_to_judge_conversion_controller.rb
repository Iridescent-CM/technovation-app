module MentorToJudgeConversionController
  extend ActiveSupport::Concern

  def create
    account = Account.find(params.fetch(:account_id))
    mentor_profile = account.mentor_profile
    judge_attrs = {
      company_name: mentor_profile.school_company_name,
      job_title: mentor_profile.job_title
    }

    unless account.judge_profile.present?
      account.create_judge_profile!(judge_attrs)
      CRM::SetupAccountForCurrentSeasonJob.perform_later(
        account_id: account.id,
        profile_type: "judge"
      )
    end

    mentor_profile.destroy

    redirect_to send("#{current_scope}_participant_path", id: account.to_param),
      success: "#{account.name} is now a judge"
  end
end
