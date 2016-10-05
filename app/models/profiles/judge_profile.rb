class JudgeProfile < ActiveRecord::Base
  include Authenticatable

  validates :company_name,
            :job_title,
            presence: true
end
