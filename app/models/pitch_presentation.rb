class PitchPresentation < ActiveRecord::Base
  belongs_to :team_submission, touch: true

  mount_uploader :uploaded_file, FileProcessor
end
