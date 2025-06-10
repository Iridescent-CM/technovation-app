class ChapterableAccountAssignmentsController < ApplicationController
  layout "application_rebrand"

  def new
    @chapterable_assignment = ChapterableAccountAssignment.new

    @chapters = ChapterSelector.new(account: current_account).call
    @primary_chapters = @chapters[:chapters_in_state_province]
    @additional_chapters = @chapters[:chapters_in_country]

    @clubs = ClubSelector.new(account: current_account).call
    @primary_clubs = @clubs[:clubs_in_state_province]
    @additional_clubs = @clubs[:clubs_in_country]
  end

  def create
    if params[:chapterable].blank?
      redirect_to new_chapterable_account_assignments_path,
        alert: "Please select a Chapter or the None of the Above option." and return
    else
      current_account
        .current_chapterable_assignments
        .where(primary: true)
        .delete_all

      if params[:chapterable] == "none_selected"
        current_account.update(no_chapterable_selected: true)
      elsif params[:chapterable] == "none_available"
        current_account.update(no_chapterables_available: true)
      else
        current_account.chapterable_assignments.create(
          profile: current_account.mentor_profile.presence || current_account.student_profile,
          chapterable_id: params[:chapterable].split.first,
          chapterable_type: params[:chapterable].split.second,
          season: Season.current.year,
          primary: true
        )
      end
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
