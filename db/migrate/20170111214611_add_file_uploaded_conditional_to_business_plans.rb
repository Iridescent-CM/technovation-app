class AddFileUploadedConditionalToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :business_plans, :file_uploaded, :boolean
  end
end
