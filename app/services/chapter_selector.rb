class ChapterSelector
  def initialize(account:)
    @account = account
  end

  def call
    find_chapters_by_state_province.presence || find_chapters_by_country
  end

  private

  attr_accessor :account

  def find_chapters_by_state_province
    select_chapters_where({
      state_province: account.state_code,
      country: account.country_code
    })
  end

  def find_chapters_by_country
    select_chapters_where({
      country: account.country_code
    })
  end

  def select_chapters_where(where_clause)
    Chapter
      .joins(legal_contact: :chapter_affiliation_agreement)
      .includes(legal_contact: :chapter_affiliation_agreement)
      .where(chapter_affiliation_agreement: {status: "signed"})
      .where(where_clause)
  end
end
