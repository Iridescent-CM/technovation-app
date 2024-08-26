class TeamSubmissionGadgetType < ActiveRecord::Base
  belongs_to :team_submission
  belongs_to :gadget_type
end
