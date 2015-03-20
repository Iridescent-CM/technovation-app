class AddCommentsToRubric < ActiveRecord::Migration
  def change
    add_column :rubrics, :identify_problem_comment, :string
    add_column :rubrics, :address_problem_comment, :string
    add_column :rubrics, :functional_comment, :string
    add_column :rubrics, :external_resources_comment, :string
    add_column :rubrics, :match_features_comment, :string
    add_column :rubrics, :interface_comment, :string
    add_column :rubrics, :description_comment, :string
    add_column :rubrics, :market_comment, :string
    add_column :rubrics, :competition_comment, :string
    add_column :rubrics, :revenue_comment, :string
    add_column :rubrics, :branding_comment, :string
    add_column :rubrics, :pitch_comment, :string
    add_column :rubrics, :launched_comment, :string
  end
end
