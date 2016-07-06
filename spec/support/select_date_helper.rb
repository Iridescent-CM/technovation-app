module SelectDateHelper
  def select_date(date, options = {})
    field = options[:from]
    base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
    year, month, day = date.strftime('%Y/%B/%-d').split('/')
    select year,  from: base_id
    select month, from: base_id.sub('1i', '2i')
    select day,   from: base_id.sub('1i', '3i')
  end
end
