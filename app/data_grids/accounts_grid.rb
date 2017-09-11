class AccountsGrid
  include Datagrid

  scope do
    Account.order(created_at: :desc)
  end

  column :first_name
  column :last_name
  column :email

  column :scope_name, header: "Profile" do
    scope_name.titleize
  end

  column :age
  column :city
  column :state_province, header: "State"

  column :created_at, header: "Signed up" do
    created_at.strftime("%b %e")
  end
end
