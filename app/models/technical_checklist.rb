class TechnicalChecklist < ActiveRecord::Base
  belongs_to :team_submission

  mount_uploader :paper_prototype, ImageUploader
  mount_uploader :event_flow_chart, ImageUploader
end
