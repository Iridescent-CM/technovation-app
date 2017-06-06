class Certificate < ApplicationRecord
  enum cert_type: %i{
    completion
    appreciation
    rpe_winner
  }

  belongs_to :account

  mount_uploader :file, FileProcessor

  def self.current
    where(season: Season.current.year).last
  end
end
