module SelectDateHelper
  def select_date(date, options = {})
    field = options[:from]
    base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
    year, month, day = date.strftime('%Y/%B/%-d').split('/')

    select year,  from: base_id
    select month, from: base_id.sub('1i', '2i')
    select day,   from: base_id.sub('1i', '3i')
  end

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    find("##{field[:id]}_chosen").click
    find("##{field[:id]}_chosen ul.chosen-results li", text: /\A#{item_text}\z/).click
  end
end
