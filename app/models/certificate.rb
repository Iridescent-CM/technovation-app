class Certificate < ApplicationRecord
  include Seasoned

  enum cert_type: %i{
    completion
    appreciation
    rpe_winner
    participation
  }

  belongs_to :account

  mount_uploader :file, FileProcessor
end
