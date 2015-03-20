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

  def format_date(d)
    d.strftime("%m/%d/%Y")
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

  def format_region(region)
    case region.to_sym
    when :ushs
      "High School - US/Canada"
    when :mexicohs
      "High School - Mexico/Central America/South America"
    when :europehs
      "High School - Europe/Australia/New Zealand/Asia"
    when :africahs
      "High School - Africa"
    when :usms
      "Middle School - US/Canada"
    when :mexicoms
      "Middle School - Mexico/Central America/South America/Africa"
    when :europems
      "Middle School - Europe/Australia/New Zealand/Asia"
    else
      "Error"
    end
  end

  def render_video(link)
    # link = 'http://www.youtube.com/embed/y4sOfO8Ei1g'
    # http://vimeo.com/channels/staffpicks/59859181
    # http://vimeo.com/originals/inthemoment/108800637
    # width = 500
    # height = 300
    if link.nil? 
      return ''
    end

    if link.include? "vimeo"
      # regex = /^http:\/\/www\.vimeo\.com\/(\d+)/
      # vid_id = link.match(regex)[1]
      tokens = link.split('/')
      vid_id = tokens[-1]
      '<iframe src="//player.vimeo.com/video/'+vid_id+'" width="500" height="300" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
    else    
      regex = /youtube.com.*(?:\/|v=)([^&$]+)/
      matches = link.match(regex)
      if matches.nil? or matches.length < 2
        return 'Your link seems broken. Please edit it.'
      end
      vid_id = matches[1]
      link = '//www.youtube.com/embed/' + vid_id
      '<iframe width="500px" height="350px" src="'+link+'"></iframe>'
    end
  end

  def render_pdf(link)
    if link.nil?
      return ''
    end

    link = link.sub('http://', 'https://')
    '<iframe width="500px" height="400px" src="' + link + '"></iframe>'
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

  def regions_to_collection
     result = Team.regions.keys.each_with_index.map{|k, i| OpenStruct.new({id: i, name: format_region(k)})}
     result.push(OpenStruct.new({id: -1, name: 'No teams mentored or coached'}))
     return result
  end

end
