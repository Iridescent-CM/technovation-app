module RegionalAmbassador
  class JudgeSearchesController < RegionalAmbassadorController
    def show
      name_query = params.fetch(:name) { "" }
      email_query = params.fetch(:email) { "" }

      judge_scope = JudgeProfile
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

      mentor_scope = MentorProfile
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

      results = judge_scope.in_region(current_ambassador).limit(7)

      if results.count < 8
        results += judge_scope.where.not(
          id: results.pluck(:id) + params[:exclude_ids].to_a,
          account_id: results.pluck(:account_id)
        )
        .limit(7 - results.count)
      end

      if results.count < 8
        results += mentor_scope.in_region(current_ambassador)
          .where.not(
            account_id: results.pluck(:account_id),
            id: results.pluck(:id) + params[:exclude_ids].to_a,
          )
          .limit(7 - results.count)
      end

      if results.count < 8
        results += mentor_scope.where.not(
          id: results.pluck(:id) + params[:exclude_ids].to_a,
          account_id: results.pluck(:account_id),
        )
        .limit(7 - results.count)
      end

      if results.count < 8
        results += UserInvitation.judge.where(
          "name ILIKE ? AND email ILIKE ?",
          "#{name_query}%", "#{email_query}%",
        )
        .where.not(
          id: results.pluck(:id) + params[:exclude_ids].to_a,
          account_id: results.pluck(:account_id)
        )
        .limit(7 - results.count)
      end

      json = results.map do |judge|
        if judge.account.present?
          judge.to_search_json.merge({
            view_url: regional_ambassador_participant_path(
              judge.account,
              allow_out_of_region: true,
            ),
          })
        else
          judge.to_search_json
        end
      end

      render json: json
    end
  end
end
