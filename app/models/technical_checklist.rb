class TechnicalChecklist < ActiveRecord::Base
  belongs_to :team_submission

  mount_uploader :paper_prototype, FileUploader
end
