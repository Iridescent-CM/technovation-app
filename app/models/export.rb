class Export < ActiveRecord::Base
  has_secure_token :download_token

  belongs_to :account

  mount_uploader :file, FileProcessor
end
