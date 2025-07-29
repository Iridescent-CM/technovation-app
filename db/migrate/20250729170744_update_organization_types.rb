class UpdateOrganizationTypes < ActiveRecord::Migration[6.1]
  OrganizationType.reset_column_information

  def up
    OrganizationType.find_by(name: "School").update(order: 10)
    OrganizationType.find_by(name: "NGO or Nonprofit Organization").update(order: 20)
    OrganizationType.find_by(name: "University").update(order: 30)
    OrganizationType.create(name: "Corporation").update(order: 35)
    OrganizationType.find_by(name: "Government Agency").update(order: 40)
    OrganizationType.find_by(name: "Other institution").update(order: 50)
  end

  def down
    OrganizationType.find_by(name: "School").update(order: nil)
    OrganizationType.find_by(name: "NGO or Nonprofit Organization").update(order: nil)
    OrganizationType.find_by(name: "University").update(order: nil)
    OrganizationType.destroy_by(name: "Corporation")
    OrganizationType.find_by(name: "Government Agency").update(order: nil)
    OrganizationType.find_by(name: "Other institution").update(order: nil)
  end
end
