class Certificate < ApplicationRecord
  belongs_to :account

  mount_uploader :file, FileProcessor
end
