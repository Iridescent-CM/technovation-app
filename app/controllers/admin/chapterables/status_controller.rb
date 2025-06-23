module Admin::Chapterables
  class StatusController < AdminController
    def active
      chapterable = if params.has_key?(:chapter_id)
        Chapter.find(params.fetch(:chapter_id))
      elsif params.has_key?(:club_id)
        Club.find(params.fetch(:club_id))
      end

      chapterable.mark_active
      msg = "Marked #{chapterable.name} active for the #{Season.current.year} season."
      redirect_to send(:"admin_#{chapterable.class.name.downcase}_path", chapterable), success: msg

    rescue ActiveRecord::RecordInvalid => e
      redirect_to send("admin_#{chapterable.class.name.downcase}_path", chapterable), error: e.record.errors.full_messages.join(" , ")
    end

    def inactive
      chapterable = if params.has_key?(:chapter_id)
        Chapter.find(params.fetch(:chapter_id))
      elsif params.has_key?(:club_id)
        Club.find(params.fetch(:club_id))
      end

      chapterable.mark_inactive
      msg = "Marked #{chapterable.name} inactive for the #{Season.current.year} season."
      redirect_to send(:"admin_#{chapterable.class.name.downcase}_path", chapterable), success: msg

    rescue ActiveRecord::RecordInvalid => e
      redirect_to send("admin_#{chapterable.class.name.downcase}_path", chapterable), error: e.record.errors.full_messages.join(" , ")
    end
  end
end
