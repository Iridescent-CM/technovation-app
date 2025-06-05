class ClubSelector
  def initialize(account:)
    @account = account
  end

  def call
    {
      clubs_in_state_province: find_clubs_in_state_province,
      clubs_in_country: find_clubs_in_country
    }
  end

  private

  attr_accessor :account

  def find_clubs_in_state_province
    select_clubs(
      where: {
        state_province: account.state_code,
        country: account.country_code
      }
    )
      .to_a
      .delete_if { |club| club == account.current_chapterable }
  end

  def find_clubs_in_country
    select_clubs(
      where: {
        country: account.country_code
      },
      where_not: {
        state_province: account.state_code
      }
    )
      .to_a
      .delete_if { |club| club == account.current_chapterable }
  end

  def select_clubs(where:, where_not: {})
    Club
      .includes(:primary_contact)
      .where(where)
      .where.not(where_not)
      .order(:name)
  end
end
