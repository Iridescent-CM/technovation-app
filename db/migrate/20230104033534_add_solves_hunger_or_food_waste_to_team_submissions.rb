class AddSolvesHungerOrFoodWasteToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :solves_hunger_or_food_waste, :boolean
    add_column :team_submissions, :solves_hunger_or_food_waste_description, :string
  end
end
