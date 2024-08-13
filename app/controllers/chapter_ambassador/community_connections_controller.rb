module ChapterAmbassador
  class CommunityConnectionsController < ChapterAmbassadorController
    skip_before_action :require_chapter_and_chapter_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    after_action :update_viewed_community_connections,
      only: :show,
      if: -> { current_chapter.present? }

    def new
      @community_connection = current_ambassador.build_community_connection
    end

    def create
      @community_connection = current_ambassador.build_community_connection(community_connection_params)

      if @community_connection.save
        redirect_to chapter_ambassador_community_connections_path,
          success: "You updated your community connection responses!"
      else
        flash.now[:alert] = "Error updating community connection responses."
        render :new
      end
    end

    def edit
      @community_connection = current_ambassador.community_connection
    end

    def update
      @community_connection = current_ambassador.community_connection

      if @community_connection.update(community_connection_params)
        redirect_to chapter_ambassador_community_connections_path,
          success: "You updated your community connection responses!"
      else
        flash.now[:alert] = "Error updating community connection responses."
        render :edit
      end
    end

    private

    def community_connection_params
      params.require(:community_connection).permit(
        :topic_sharing_response,
        availability_slot_ids: []
      )
    end

    def update_viewed_community_connections
      current_ambassador.update(viewed_community_connections: true)
    end
  end
end
