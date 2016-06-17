class StudentProfile < ActiveRecord::Base
  belongs_to :authentication_role
end
