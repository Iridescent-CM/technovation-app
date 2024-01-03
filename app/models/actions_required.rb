class ActionsRequired
  include Enumerable

  attr_reader :feature, :actions

  def initialize(feature, actions)
    @feature = feature
    @actions = actions
    freeze
  end

  def each(&block)
    @actions.each { |a| block.call(ActionRequired.new(a)) }
  end

  def as_html_list
    if feature.requires_action?
      "<ul><li>#{map(&:message).join("</li><li>")}</li></ul>".html_safe
    else
      ""
    end
  end
end
