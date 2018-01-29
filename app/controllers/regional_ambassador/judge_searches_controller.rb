module RegionalAmbassador
  class JudgeSearchesController < RegionalAmbassadorController
    def show
      results = JudgeProfile.current
        .in_region(current_ambassador)
        .where(
          "accounts.first_name ILIKE ? OR
           accounts.last_name ILIKE ? OR
           accounts.email ILIKE ?",
          "#{params[:keyword]}%",
          "#{params[:keyword]}%",
          "#{params[:keyword]}%"
        )
        .map do |r|
          {
            name: r.full_name,
            email: r.email,
          }
        end

      render json: results
    end
  end
end
