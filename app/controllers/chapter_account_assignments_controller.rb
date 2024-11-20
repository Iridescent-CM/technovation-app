class ChapterAccountAssignmentsController < ApplicationController
  layout "application_rebrand"

  def new
    @chapter_assignment = ChapterAccountAssignment.new

    all_chapters = ChapterSelector.new(account: current_account).call
    @primary_chapters = all_chapters[:chapters_in_state_province]
    @additional_chapters = all_chapters[:chapters_in_country]
  end

  def create
    if params[:chapter_id].blank?
      redirect_to new_chapter_account_assignments_path,
        alert: "Please select a Chapter or the None of the Above option." and return
    elsif params[:chapter_id] == "none_selected"
      current_account.update(no_chapter_selected: true)
    else
      current_account.chapter_assignments.create(
        profile: current_account.mentor_profile.presence || current_account.student_profile,
        chapter_id: params[:chapter_id],
        season: Season.current.year,
        primary: true
      )
    end

    if current_account.is_a_mentor?
      current_account.mentor_profile.update(
        virtual: params.fetch(:mentor_profile_virtual, false),
        accepting_team_invites: params.fetch(:mentor_profile_accepting_team_invites, false)
      )
    end

    redirect_to send(:"#{current_account.scope_name}_dashboard_path")
  end
end
