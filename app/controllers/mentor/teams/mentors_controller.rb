module Mentor::Teams
  class MentorsController < MentorController
    include MentorTeamDetailsConcern
    layout "mentor_rebrand"
  end
end