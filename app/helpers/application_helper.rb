module ApplicationHelper
  def al(path)
    request.fullpath == path ? "active" : ""
  end
end
