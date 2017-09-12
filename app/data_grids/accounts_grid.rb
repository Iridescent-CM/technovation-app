class AccountsGrid
  include Datagrid

  attr_accessor :ambassador

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

  filter :name do |value|
    names = value.split(' ')
    where(
      "accounts.first_name ilike '%#{names.first}%' OR
       accounts.last_name ilike '%#{names.last}%'"
    )
  end

  filter :email do |value|
    where("accounts.email ilike '%#{value}%'")
  end

  filter(:city, if: ->(g) { g.ambassador.country != "US" }) do |value|
    where("accounts.city ilike '%#{value}%'")
  end

  filter :city,
    :enum,
    select: ->(g) {
      CS.cities(g.ambassador.state_province, :us)
    },
    if: ->(g) { g.ambassador.country == "US" }


  filter :state_province,
    :enum,
    header: "State / Province",
    select: ->(g) {
      CS.states(g.ambassador.country).map { |p| [p[1], p[0]] }.compact
    },
    if: ->(g) { g.ambassador.country != "US" }

  filter :scope_names,
    :enum,
    header: "Profile type",
    select: [
      ['Students', 'student'],
      ['Mentors', 'mentor'],
      ['Judges', 'judge'],
      ['Regional Ambassadors', 'regional_ambassador'],
    ],
    checkboxes: true do |values|
      clauses = values.map { |v| "#{v}_profiles.id IS NOT NULL" }
      where(clauses.join(' AND '))
    end
end
