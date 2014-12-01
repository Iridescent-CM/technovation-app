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
end
