class UnaffiliatedParticipantsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :chapter_id

  self.batch_size = 1_000

  scope do
    Account
  end

  column :id, header: "Participant ID"

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true

  column :city, mandatory: true

  column :state_province, mandatory: true, header: "State" do |account, _grid|
    FriendlySubregion.call(account, prefix: false)
  end

  column :country, mandatory: true do |account, _grid|
    FriendlyCountry.new(account).country_name
  end

  column :actions, mandatory: true, html: true do |account, grid|
    link_to "Add to your chapter",
      chapter_ambassador_account_chapter_account_assignments_path(
        account_id: account.id,
        chapter_account_assignment: {chapter_id: grid.chapter_id}
      ),
      class: "button button--remove-bg",
      data: {
        method: :post,
        confirm: "You are adding #{account.full_name} to your chapter!",
      }
  end

  filter :name_email,
    header: "Name or Email",
    filter_group: "more-specific" do |value|
      names = value.strip.downcase.split(" ").map { |n|
        I18n.transliterate(n).gsub("'", "''")
      }
      fuzzy_search({
        first_name: names.first,
        last_name: names.last || names.first,
        email: names.first
      }, false) # false enables OR search
    end

  filter :first_name,
    header: "First name (exact spelling)",
    filter_group: "more-specific" do |value|
      basic_search({
        first_name: value
      })
    end

  filter :last_name,
    header: "Last name (exact spelling)",
    filter_group: "more-specific" do |value|
      basic_search({
        last_name: value
      })
    end

  filter :email,
    header: "Email (exact spelling)",
    filter_group: "more-specific" do |value|
      basic_search({
        email: value
      })
    end

  filter :country,
    :enum,
    header: "Country",
    select: ->(g) {
      CountryStateSelect.countries_collection
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing..."
    },
    if: ->(g) { g.admin } do |values|
      clauses = values.flatten.map { |v| "accounts.country = '#{v}'" }
      where(clauses.join(" OR "))
    end

  filter :state_province,
    :enum,
    header: "State / Province",
    select: ->(g) {
      CS.get(g.country[0]).map { |s| [s[1], s[0]] }
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing..."
    },
    if: ->(grid) { GridCanFilterByState.call(grid) } do |values, scope, grid|
      scope.where(country: grid.country)
        .where(
          StateClauses.for(
            values: values,
            countries: grid.country,
            table_name: "accounts",
            operator: "OR"
          )
        )
    end

  filter :city,
    :enum,
    select: ->(g) {
      country = g.country[0]
      state = g.state_province[0]
      CS.get(country, state)
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing..."
    },
    if: ->(grid) { GridCanFilterByCity.call(grid) } do |values, scope, grid|
      scope.where(
        StateClauses.for(
          values: grid.state_province[0],
          countries: grid.country,
          table_name: "accounts",
          operator: "OR"
        )
      )
        .where(
          CityClauses.for(
            values: values,
            table_name: "accounts",
            operator: "OR"
          )
        )
    end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
