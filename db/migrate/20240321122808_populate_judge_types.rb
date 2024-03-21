class PopulateJudgeTypes < ActiveRecord::Migration[6.1]
  def up
    JudgeType.create(name: "Educator", order: 1)
    JudgeType.create(name: "Industry professional", order: 2)
    JudgeType.create(name: "Postsecondary student", order: 3)
    JudgeType.create(name: "Parent", order: 4)
    JudgeType.create(name: "Technovation alumnae", order: 5)
  end

  def down
    JudgeType.delete_all
  end
end
