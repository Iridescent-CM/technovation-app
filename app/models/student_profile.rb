class StudentProfile < ActiveRecord::Base
  include Authenticatable

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
            presence: true
end
