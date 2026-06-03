class PopulateMentorTypes < ActiveRecord::Migration[6.1]
  def up
    MentorType.create(name: "Industry professional", order: 1)
    MentorType.create(name: "Educator", order: 2)
    MentorType.create(name: "Parent", order: 3)
    MentorType.create(name: "Technovation alumnae", order: 4)
    MentorType.create(name: "Postsecondary student", order: 5)
  end

  def down
    MentorType.delete_all
  end
end
