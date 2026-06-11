class AddOrganizationStatusToChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE chapter_ambassador_organization_status AS ENUM ('employee', 'volunteer');
    SQL

    add_column :chapter_ambassador_profiles, :organization_status, :chapter_ambassador_organization_status
  end

  def down
    remove_column :chapter_ambassador_profiles, :organization_status

    execute <<-SQL
      DROP TYPE chapter_ambassador_organization_status;
    SQL
  end
end
