class ChapterAccountAssignmentsController < ApplicationController
  layout "application_rebrand"

  def new
    @chapter_assignment = ChapterAccountAssignment.new
    @chapters = ChapterSelector.new(account: current_account).call
  end

  def create
    if params[:chapter_id] == "none_selected"
      current_account.update(no_chapter_selected: true)
    else
      current_account.chapter_assignments.create(
        profile: current_account.current_profile,
        chapter_id: params[:chapter_id],
        season: Season.current.year,
        primary: true
      )
    end

    redirect_to send(:"#{current_account.scope_name}_dashboard_path")
  end
end
