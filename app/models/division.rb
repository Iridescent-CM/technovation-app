class Division < ActiveRecord::Base
  enum name: [:high_school, :middle_school, :not_assigned]
end
