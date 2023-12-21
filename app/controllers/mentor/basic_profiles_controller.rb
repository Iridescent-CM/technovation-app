module Mentor
  class BasicProfilesController < MentorController
    include BasicProfileController

    with_profile :current_mentor

    with_params :school_company_name, :job_title, :mentor_type, expertise_ids: []
  end
end
