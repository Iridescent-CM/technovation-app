class StudentProfile < ActiveRecord::Base
  include Authenticatable

  validates :parent_guardian_email, presence: true
end
