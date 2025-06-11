module Admin::Ambassadors
  class SeasonStatusController < AdminController
    def update
      chapterable = if params.has_key?(:chapter_id)
        Chapter.find(params.fetch(:chapter_id))
      elsif params.has_key?(:club_id)
        Club.find(params.fetch(:club_id))
      end

      if params[:active] == "true"
        chapterable.mark_active_for_current_season
        msg = "Marked #{chapterable.name} active for the #{Season.current.year} season."
      else
        chapterable.mark_inactive_for_current_season
        msg = "Marked #{chapterable.name} inactive for the #{Season.current.year} season."
      end

      redirect_to send(:"admin_#{chapterable.class.name.downcase}_path", chapterable), success: msg

    rescue ActiveRecord::RecordInvalid => e
      redirect_to send("admin_#{chapterable.class.name.downcase}_path", chapterable), error: e.record.errors.full_messages.join(" , ")
    end
  end
end
