module Admin::ChapterableStatusConcern
  extend ActiveSupport::Concern
  def activate
    if @chapterable.activate
      msg = "#{@chapterable.name} has been activated for the #{Season.current.year} season."
      redirect_to send(:"admin_#{@chapterable.class.name.downcase}_path", @chapterable), success: msg
    else
      msg = "Error activating #{@chapterable.name} for the #{Season.current.year} season."
      redirect_to send(:"admin_#{@chapterable.class.name.downcase}_path", @chapterable), error: msg
    end
  end

  def deactivate
    if @chapterable.deactivate
      msg = "#{@chapterable.name} has been deactivated for the #{Season.current.year} season."
      redirect_to send(:"admin_#{@chapterable.class.name.downcase}_path", @chapterable), success: msg
    else
      msg = "Error deactivating #{@chapterable.name} for the #{Season.current.year} season."
      redirect_to send(:"admin_#{@chapterable.class.name.downcase}_path", @chapterable), error: msg
    end
  end
end
