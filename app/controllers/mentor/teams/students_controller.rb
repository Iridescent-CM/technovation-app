module Mentor::Teams
  class StudentsController < MentorController
    include MentorTeamDetailsConcern
    layout "mentor_rebrand"
  end
end