class Certificate < ApplicationRecord
  include Seasoned

  enum cert_type: %i{
    completion
    mentor_appreciation
    rpe_winner
    participation
    semifinalist
    general_judge
  }

  belongs_to :account
  belongs_to :team

  mount_uploader :file, FileProcessor
end