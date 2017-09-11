class AccountsGrid
  include Datagrid

  scope do
    Account.order(created_at: :desc)
  end

  column :first_name
  column :last_name
  column :email
  column :created_at do
    self.created_at.to_date
  end
end
