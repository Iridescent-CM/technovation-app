ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if  Nokogiri::HTML::fragment(html_tag).children[0].name == "input"
    span =  %Q(<span class="error">#{Array(instance.error_message).join("\n")}</span>)
    %Q(<div class="field_with_errors">#{html_tag}#{span}</div>).html_safe
  else
    %Q(<div class="field_with_errors">#{html_tag}</div>).html_safe
  end
end
