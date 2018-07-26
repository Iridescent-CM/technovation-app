module VueSelectInputHelper
  def fill_in_vue_select(selector, options)
    options[:with] = "#{options[:with]}\n"
    fill_in(selector, options)
  end
end