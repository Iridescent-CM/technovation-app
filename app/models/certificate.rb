class Certificate < ApplicationRecord
  belongs_to :account

  mount_uploader :file, FileProcessor

  def self.current
    where(season: Season.current.year).last
  end
end
