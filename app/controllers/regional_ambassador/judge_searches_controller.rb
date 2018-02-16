module RegionalAmbassador
  class JudgeSearchesController < RegionalAmbassadorController
    def show
      name_query = params.fetch(:name) { "" }
      email_query = params.fetch(:email) { "" }

      scope = JudgeProfile
        .includes(:account)
        .references("accounts")
        .where(
          "accounts.first_name ILIKE ? AND
           accounts.last_name ILIKE ? AND
           accounts.email ILIKE ?",
           "#{name_query.split(" ")[0]}%",
           "#{name_query.split(" ")[1]}%",
           "#{email_query}%",
        )
        .where.not(id: params[:exclude_ids])

      results = scope.in_region(current_ambassador).limit(7)

      if results.count < 8
        results += scope.where.not(
                          id: results.pluck(:id) + params[:exclude_ids].to_a
                        )
                        .limit(7 - results.count)
      end

      if results.count < 8
        results += UserInvitation.where(
          "name ILIKE ? OR email ILIKE ?",
          "#{name_query}%", "#{email_query}%",
        )
        .where.not(
          id: results.pluck(:id) + params[:exclude_ids].to_a
        )
        .limit(7 - results.count)
      end

      render json: results.map(&:to_search_json)
    end
  end
end
