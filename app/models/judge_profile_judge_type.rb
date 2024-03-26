class JudgeProfileJudgeType < ActiveRecord::Base
  belongs_to :judge_profile
  belongs_to :judge_type
end
