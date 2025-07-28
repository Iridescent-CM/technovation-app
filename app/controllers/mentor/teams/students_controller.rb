module Mentor::Teams
  class StudentsController < MentorController
    include TeamController
    layout "mentor_rebrand"
  end
end