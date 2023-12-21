module SelectDateHelper
  def select_date(date, options = {})
    field = options[:from]
    base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
    year, month, day = date.strftime("%Y/%B/%-d").split("/")
    select year, from: base_id
    select month, from: base_id.sub("1i", "2i")
    select day, from: base_id.sub("1i", "3i")
  end

  def select_chosen_date(date, options = {})
    year, month, day = date.strftime("%Y/%B/%-d").split("/")

    field = find_field(options[:from], visible: false)

    base_id = find(:xpath, ".//label[contains(.,'#{options[:from]}')]")[:for]
    month_id = base_id.sub("1i", "2i")
    day_id = base_id.sub("1i", "3i")

    select_chosen_field(base_id, year)
    select_chosen_field(month_id, month)
    select_chosen_field(day_id, day)
  end

  private

  def select_chosen_field(id, year)
    find("##{id}_chosen").click
    find(
      "##{id}_chosen ul.chosen-results li",
      text: /\A#{Regexp.quote(year)}\z/
    ).click
  end
end
