module VueSelectInputHelper
  def fill_in_vue_select(selector, options)
    find_field(selector).send_keys(options[:with], :enter)
  end
end
