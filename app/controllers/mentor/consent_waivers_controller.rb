module Mentor
  class ConsentWaiversController < MentorController
    include ConsentWaiverController
    layout "mentor_rebrand"
  end
end
