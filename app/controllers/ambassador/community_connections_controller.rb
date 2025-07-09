module Ambassador
  class CommunityConnectionsController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    after_action :update_viewed_community_connections,
      only: :show,
      if: -> { current_chapterable.present? }

    layout :set_layout_for_current_ambassador

    def new
      @community_connection = current_ambassador.build_community_connection
    end

    def create
      @community_connection = current_ambassador.build_community_connection(community_connection_params)

      if @community_connection.save

        redirect_to send(:"#{current_scope}_community_connections_path"),
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
        redirect_to send(:"#{current_scope}_community_connections_path"),
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
