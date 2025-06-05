class ChapterSelector
  def initialize(account:)
    @account = account
  end

  def call
    {
      chapters_in_state_province: find_chapters_in_state_province,
      chapters_in_country: find_chapters_in_country
    }
  end

  private

  attr_accessor :account

  def find_chapters_in_state_province
    select_chapters(
      where: {
        state_province: account.state_code,
        country: account.country_code
      }
    )
      .to_a
      .delete_if { |chapter| chapter == account.current_chapterable }
  end

  def find_chapters_in_country
    select_chapters(
      where: {
        country: account.country_code
      },
      where_not: {
        state_province: account.state_code
      }
    )
      .to_a
      .delete_if { |chapter| chapter == account.current_chapterable }
  end

  def select_chapters(where:, where_not: {})
    Chapter
      .joins(legal_contact: :chapter_affiliation_agreement)
      .includes(legal_contact: :chapter_affiliation_agreement)
      .includes(:primary_contact)
      .where(chapter_affiliation_agreement: {status: ["signed", "off-platform"]})
      .where(where)
      .where.not(where_not)
      .order(:name)
  end
end
