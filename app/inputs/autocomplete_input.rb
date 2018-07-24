class AutocompleteInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    if merged_input_options[":options".to_sym]
      merged_input_options[":options".to_sym] = merged_input_options[":options".to_sym].to_s
    end

    merged_input_options[:id] = "#{object_name.to_s}_#{attribute_name.to_s}"
    merged_input_options[:name] = "#{object_name.to_s}[#{attribute_name.to_s}]"

    merged_input_options["no-options-text"] = merged_input_options[:no_options_text]
    merged_input_options.delete(:no_options_text)

    template.content_tag(
      :div,
      template.content_tag("autocomplete-input", "", merged_input_options),
      class: "vue-enable-autocomplete-input"
    )
  end
end