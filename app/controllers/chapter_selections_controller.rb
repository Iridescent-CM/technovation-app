class ChapterSelectionsController < ApplicationController
  layout "application_rebrand"

  def show
    @chapters = ChapterSelector.new(account: current_account).call
  end
end
