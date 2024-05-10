class PopulateOrganizationTypes < ActiveRecord::Migration[6.1]
  def up
    OrganizationType.create(name: "School", order: 1)
    OrganizationType.create(name: "NGO or Nonprofit Organization", order: 2)
    OrganizationType.create(name: "University", order: 3)
    OrganizationType.create(name: "Government Agency", order: 4)
    OrganizationType.create(name: "Other institution", order: 5)
  end

  def down
    OrganizationType.delete_all
  end
end
