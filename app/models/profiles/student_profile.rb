class StudentProfile < ActiveRecord::Base
  include Authenticatable

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
            :is_in_secondary_school,
            presence: true
end
