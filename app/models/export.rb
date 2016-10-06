class Export < ActiveRecord::Base
  belongs_to :account
  mount_uploader :file, FileProcessor
end
