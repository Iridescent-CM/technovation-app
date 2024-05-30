module ChapterAmbassador
  class CommunityConnectionsController < ChapterAmbassadorController
    layout "chapter_ambassador_rebrand"

    after_action :update_viewed_community_connections, only: :show

    private

    def update_viewed_community_connections
      current_ambassador.update(viewed_community_connections: true)
    end
  end
end
