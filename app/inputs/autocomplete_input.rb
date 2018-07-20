class AutocompleteInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    if merged_input_options[":options".to_sym]
      merged_input_options[":options".to_sym] = merged_input_options[":options".to_sym].to_s
    end

    template.content_tag(
      :div,
      content_tag("autocomplete-input", "", merged_input_options),
      class: "vue-enable-autocomplete-input"
    )
  end
end