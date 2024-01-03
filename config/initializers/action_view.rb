ActionView::Base.field_error_proc = proc do |html_tag, instance|
  tag = Nokogiri::HTML.fragment(html_tag).children[0]

  type = tag.attributes.fetch("type") {
    TechnovationApp::FormErrorProc::NullType.new("null")
  }.value

  html = ""

  if tag.name == "input" && type != "checkbox"
    span = %(<span class="error">#{Array(instance.error_message).join("\n")}</span>)
    html = %(<div class="field_with_errors">#{html_tag}#{span}</div>)
  elsif tag.name == "input" && type == "checkbox"
    html = html_tag
  elsif tag.name == "label" || tag.name == "textarea"
    span = %(<span class="error">#{Array(instance.error_message).join("\n")}</span>)
    html = %(<span class="field_with_errors">#{html_tag}#{span}</span>)
  else
    html = %(<div class="field_with_errors">#{html_tag}</div>)
  end

  html.html_safe
end

module TechnovationApp
  module FormErrorProc
    NullType = Struct.new(:value)
  end
end
