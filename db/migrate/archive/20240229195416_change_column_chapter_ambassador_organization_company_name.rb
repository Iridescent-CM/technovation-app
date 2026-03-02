class ChangeColumnChapterAmbassadorOrganizationCompanyName < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:chapter_ambassador_profiles, :organization_company_name, true)
  end
end
