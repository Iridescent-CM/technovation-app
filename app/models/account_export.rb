class AccountExport < ActiveRecord::Base
  belongs_to :regional_ambassador_account
  mount_uploader :file, FileUploader
end
