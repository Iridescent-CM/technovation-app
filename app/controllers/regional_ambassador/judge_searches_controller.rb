module RegionalAmbassador
  class JudgeSearchesController < RegionalAmbassadorController
    def show
      keyword = params.fetch(:keyword) { "" }

      results = JudgeProfile
        .joins(:account)
        .where(
          "accounts.first_name ILIKE ? OR
           accounts.last_name ILIKE ? OR
           accounts.email ILIKE ?",
          "#{keyword.split(" ").first}%",
          "#{keyword.split(" ").last}%",
          "#{keyword}%"
        )
        .limit(7)
        .map do |r|
          {
            id: r.id,
            name: r.full_name,
            email: r.email,
          }
        end

      render json: results
    end
  end
end
