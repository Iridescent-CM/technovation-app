module ApplicationHelper
  def strikethrough(should, &block)
    if should
      "<s>#{capture(&block)}</s>".html_safe
    else
      capture(&block).html_safe
    end
  end

  def format_division(division)
    if division.to_sym == :hs
      "High School"
    elsif division.to_sym == :ms
      "Middle School"
    else
      "Error"
    end
  end

  def format_region(region, division)
    case division.to_sym
    when :us
      "US/Canada"
    when :mexico
      if division.to_sym == :hs
        "Mexico/Central America/South America/Africa"
      else
        "Mexico/Central America/South America/Africa"
      end
    when :africa
      "Africa"
    when :europe
      "Europe/Australia/New Zealand/Asia"
    else
      "Error"
    end
  end

  def doc_path(file)
    File.join('/docs', file).to_s
  end


  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, no_images: true, hard_wrap: true)
    md = Redcarpet::Markdown.new(renderer, tables: true, fenced_code_blocks: true, strikethrough: true, superscript: true, underline: true, highlight: true)
    md.html_safe
  end
end
