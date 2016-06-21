class StudentProfile < ActiveRecord::Base
  include Authenticatable

  validates :date_of_birth, presence: true

  validates :parent_guardian_email, presence: true
end
