module Mentor::Teams
  class DivisionController < MentorController
    include MentorTeamDetailsConcern
    layout "mentor_rebrand"
  end
end
