class Certificate < ApplicationRecord
  include Seasoned

  enum cert_type: CERTIFICATE_TYPES

  belongs_to :account
  belongs_to :team, required: false

  mount_uploader :file, FileProcessor

  scope :judge_types, -> {
    where(cert_type: CERTIFICATE_TYPES.select { |t| t.include?('judge') })
  }

  scope :for_team, -> (team) {
    where(team: team)
  }
end