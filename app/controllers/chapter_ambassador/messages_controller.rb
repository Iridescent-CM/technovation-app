module ChapterAmbassador
  class MessagesController < ChapterAmbassadorController
    def show
      @message = current_ambassador.messages.find(params[:id])
    end

    def new
      recipient = params.fetch(:recipient_type).constantize.find(params.fetch(:recipient_id))
      regarding = params.fetch(:regarding_type).constantize.find(params.fetch(:regarding_id))

      @message = current_ambassador.messages.build(
        recipient: recipient,
        regarding: regarding
      )
    end

    def edit
      @message = current_ambassador.messages.unsent.find(params[:id])
    end

    def create
      @message = current_ambassador.messages.build(message_params)

      if @message.save
        redirect_to chapter_ambassador_path(@message),
          success: "Your message is ready to send"
      else
        render :new
      end
    end

    def update
      @message = current_ambassador.messages.unsent.find(params[:id])

      if @message.update(message_params)
        redirect_to chapter_ambassador_path(@message),
          success: "Your message is ready to send"
      else
        render :edit
      end
    end

    def destroy
      current_ambassador.messages.find(params[:id]).destroy
      redirect_back fallback_location: chapter_ambassador_dashboard_path,
        success: "The message was deleted"
    end

    private

    def message_params
      params.require(:message).permit(
        :recipient_type,
        :recipient_id,
        :regarding_type,
        :regarding_id,
        :subject,
        :body
      )
    end
  end
end
