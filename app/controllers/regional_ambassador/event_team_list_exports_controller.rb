module RegionalAmbassador
  class EventTeamListExportsController < RegionalAmbassadorController
    def create
      ExportEventAttendeesJob.perform_later(
        current_ambassador.id,
        params.fetch(:id),
        self.class.name,
        "teams",
      )
      render json: {}
    end
  end
end