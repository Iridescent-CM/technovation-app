class Export < ActiveRecord::Base
  has_secure_token :download_token

  belongs_to :owner, polymorphic: true

  mount_uploader :file, FileProcessor

  scope :owned_by, ->(owner) { where(owner: owner) }
  scope :undownloaded, -> { where(downloaded: false) }
end
