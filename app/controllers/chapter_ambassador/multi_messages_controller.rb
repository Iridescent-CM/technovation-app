module ChapterAmbassador
  class MultiMessagesController < ChapterAmbassadorController
    def show
      @message = current_ambassador.multi_messages.find(params[:id])
      render 'chapter_ambassador/messages/show'
    end

    def new
      regarding = params.fetch(:regarding_type).constantize.find(params.fetch(:regarding_id))

      @message = current_ambassador.multi_messages.build(
        team: params[:team],
        regarding: regarding
      )
      render 'chapter_ambassador/messages/new'
    end

    def edit
      @message = current_ambassador.multi_messages.unsent.find(params[:id])
      render 'chapter_ambassador/messages/edit'
    end

    def create
      @message = current_ambassador.multi_messages.build(message_params)

      if @message.save
        redirect_to [:chapter_ambassador, @message],
          success: "Your message is ready to send"
      else
        render 'chapter_ambassador/messages/new'
      end
    end

    def update
      @message = current_ambassador.multi_messages.unsent.find(params[:id])

      if @message.update_attributes(message_params)
        redirect_to [:chapter_ambassador, @message],
          success: "Your message is ready to send"
      else
        render 'chapter_ambassador/messages/edit'
      end
    end

    def destroy
      current_ambassador.multi_messages.find(params[:id]).destroy
      redirect_back fallback_location: chapter_ambassador_dashboard_path,
        success: "The message was deleted"
    end

    private
    def message_params
      params.require(:multi_message).permit(
        :team,
        :judge_profile,
        :regarding_type,
        :regarding_id,
        :subject,
        :body
      )
    end
  end
end
