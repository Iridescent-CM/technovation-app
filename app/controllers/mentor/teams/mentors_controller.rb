module Mentor::Teams
  class MentorsController < MentorController
    include TeamController
    layout "mentor_rebrand"
  end
end