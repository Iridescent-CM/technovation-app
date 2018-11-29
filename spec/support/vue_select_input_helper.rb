module VueSelectInputHelper
  def fill_in_vue_select(selector, options)
    options[:with] = "#{options[:with]}\n"
    fill_in(selector, options)
  end

  def select_vue_select_option(selector, options)
    page.find(selector, wait: 10).click
    page.find(".dropdown-menu li a", text: options[:option], exact_text: true).click
  end
end