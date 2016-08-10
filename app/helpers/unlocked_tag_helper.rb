module UnlockedTagHelper
  def unlocked_link_to(user, link_text, link_path, link_options = {})
    if unlocked?(user, link_path)
      link_to(link_text, link_path, link_options)
    end
  end

  def unlocked_content_tag(user, path, tag_name, content, tag_options = {})
    if unlocked?(user, path)
      content_tag(tag_name, content, tag_options)
    end
  end

  private
  def unlocked?(user, path)
    CompletionSteps.new(user).unlocked?(path)
  end
end
