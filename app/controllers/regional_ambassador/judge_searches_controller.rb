module RegionalAmbassador
  class JudgeSearchesController < RegionalAmbassadorController
    def show
      keyword = params.fetch(:keyword) { "" }

      results = JudgeProfile
        .in_region(current_ambassador)
        .joins(:account)
        .where(
          "accounts.first_name ILIKE ? OR
           accounts.last_name ILIKE ? OR
           accounts.email ILIKE ?",
          "#{keyword.split(" ").first}%",
          "#{keyword.split(" ").last}%",
          "#{keyword}%"
        )
        .where.not(id: params[:except_ids])
        .limit(7)

      if results.count < 7
        results += JudgeProfile
          .joins(:account)
          .where(
            "accounts.first_name ILIKE ? OR
              accounts.last_name ILIKE ? OR
              accounts.email ILIKE ?",
            "#{keyword.split(" ").first}%",
            "#{keyword.split(" ").last}%",
            "#{keyword}%"
          )
          .where.not(id: results.pluck(:id) + params[:except_ids].to_a)
          .limit(7 - results.count)
      end

      render json: results.map(&:to_search_json)
    end
  end
end
