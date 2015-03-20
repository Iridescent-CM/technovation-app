class AddUserRefToRubrics < ActiveRecord::Migration
  def change
    add_reference :rubrics, :user, index: true
  end
end
