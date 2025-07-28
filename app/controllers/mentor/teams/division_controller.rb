module Mentor::Teams
  class DivisionController < MentorController
    include TeamController
    layout "mentor_rebrand"
  end
end
