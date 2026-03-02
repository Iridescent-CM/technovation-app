class PopulateOrganizationTypes < ActiveRecord::Migration[6.1]
  def up
    OrganizationType.create(name: "School")
    OrganizationType.create(name: "NGO or Nonprofit Organization")
    OrganizationType.create(name: "University")
    OrganizationType.create(name: "Government Agency")
    OrganizationType.create(name: "Other institution")
  end

  def down
    OrganizationType.delete_all
  end
end
