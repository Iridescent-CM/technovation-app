class GadgetType < ActiveRecord::Base
  has_many :team_submission_gadget_types
  has_many :team_submissions, through: :team_submission_gadget_types
end
