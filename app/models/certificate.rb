class Certificate < ApplicationRecord
  include Seasoned

  enum cert_type: CERTIFICATE_TYPES

  belongs_to :account
  belongs_to :team, required: false

  mount_uploader :file, FileProcessor
end