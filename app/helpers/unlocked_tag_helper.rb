module UnlockedTagHelper
  def unlocked_link_to(user, link_text, link_path, link_options = {})
    if unlocked?(user, link_path)
      link_to(link_text, link_path, link_options)
    end
  end

  def unlocked_content_tag(user, path, tag_name, content = nil, tag_options = nil, &block)
    if unlocked?(user, path)
      if block_given?
        content_tag(tag_name, tag_options, &block)
      else
        content_tag(tag_name, content, tag_options)
      end
    end
  end

  private
  def unlocked?(user, path)
    CompletionSteps.new(user).unlocked?(path)
  end
end
