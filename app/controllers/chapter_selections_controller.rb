class ChapterSelectionsController < ApplicationController
  layout "application_rebrand"

  def show
    @chapter_assignment = ChapterAccountAssignment.new
    @chapters = ChapterSelector.new(account: current_account).call
  end
end
