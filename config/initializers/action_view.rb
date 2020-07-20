ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  tag = Nokogiri::HTML::fragment(html_tag).children[0]

  type = tag.attributes.fetch("type") {
    TechnovationApp::FormErrorProc::NullType.new("null")
  }.value

  html = ""

  if tag.name == "input" && type != "checkbox"
    span =  %Q(<span class="error">#{Array(instance.error_message).join("\n")}</span>)
    html = %Q(<div class="field_with_errors">#{html_tag}#{span}</div>)
  elsif tag.name == "input" && type == "checkbox"
    html = html_tag
  elsif tag.name == "label"
    span =  %Q(<span class="error">#{Array(instance.error_message).join("\n")}</span>)
    html = %Q(<span class="field_with_errors">#{html_tag}#{span}</span>)
  else
    html = %Q(<div class="field_with_errors">#{html_tag}</div>)
  end

  html.html_safe
end

module TechnovationApp
  module FormErrorProc
    NullType = Struct.new(:value)
  end
end
