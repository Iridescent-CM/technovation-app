module ApplicationHelper
  require 'redcarpet/render_strip'

  def link_user(user)
    if policy(user).show?
      link_to user.name, user
    else
      user.name
    end
  end

  def strikethrough(should, &block)
    if should
      "<s>#{capture(&block)}</s>".html_safe
    else
      capture(&block).html_safe
    end
  end

  def format_division(division)
    case division.to_sym
    when :hs
      'High School'
    when :ms
      'Middle School'
    when :x
      'Ineligible'
    else
      'Error'
    end
  end

  def format_region(region, division)
    case region.to_sym
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
    unless text == nil
      renderer = Redcarpet::Render::HTML.new(filter_html: true, no_images: true, hard_wrap: true)
      parser = Redcarpet::Markdown.new(renderer, tables: true, fenced_code_blocks: true, strikethrough: true, superscript: true, underline: true, highlight: true)
      parser.render(text).html_safe
    end
  end

  def render_markdown_brief(text)
    unless text == nil
      renderer = Redcarpet::Render::StripDown.new()
      parser = Redcarpet::Markdown.new(renderer, tables: true, fenced_code_blocks: true, strikethrough: true, superscript: true, underline: true, highlight: true)
      parser.render(text)
    end
  end
end
