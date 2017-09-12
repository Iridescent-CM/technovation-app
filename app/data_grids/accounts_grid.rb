class AccountsGrid
  include Datagrid

  scope do
    Account.left_outer_joins([
      :student_profile,
      :mentor_profile,
      :judge_profile,
      :regional_ambassador_profile,
    ])
      .order("accounts.created_at desc")
  end

  column :first_name
  column :last_name
  column :email

  column :age, order: "accounts.date_of_birth desc"
  column :city
  column :state_province, header: "State"

  column :created_at, header: "Signed up" do
    created_at.strftime("%b %e")
  end
end
