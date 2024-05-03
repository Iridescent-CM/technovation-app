class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options)
    template.content_tag(:div, super, class: "custom-simpleform-date")
  end
end