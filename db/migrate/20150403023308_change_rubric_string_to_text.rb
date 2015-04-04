class ChangeRubricStringToText < ActiveRecord::Migration
  def change
    change_column :rubrics, :identify_problem_comment, :text
    change_column :rubrics, :address_problem_comment, :text
    change_column :rubrics, :functional_comment, :text
    change_column :rubrics, :external_resources_comment, :text
    change_column :rubrics, :match_features_comment, :text
    change_column :rubrics, :interface_comment, :text
    change_column :rubrics, :description_comment, :text
    change_column :rubrics, :market_comment, :text
    change_column :rubrics, :competition_comment, :text
    change_column :rubrics, :revenue_comment, :text
    change_column :rubrics, :branding_comment, :text
    change_column :rubrics, :pitch_comment, :text
    change_column :rubrics, :launched_comment, :text
  end
end
