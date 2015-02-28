class AddTeamRefToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :team, index: true
  end
end
