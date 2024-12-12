class ChapterSelectionsController < ApplicationController
  layout "application_rebrand"

  def show
    @chapterable_assignment = ChapterableAccountAssignment.new
    @chapters = ChapterSelector.new(account: current_account).call
  end
end
