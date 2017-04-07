class AddFileUploadedConditionalToBusinessPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :business_plans, :file_uploaded, :boolean
  end
end
