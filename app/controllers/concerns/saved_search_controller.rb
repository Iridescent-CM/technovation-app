module SavedSearchController
  extend ActiveSupport::Concern

  included do
    # no op
  end

  def show
    @saved_search = current_profile.saved_searches.find(params[:id])

    path_name = case @saved_search.param_root
    when "accounts_grid"
      "#{current_scope}_participants_path"
    when "teams_grid"
      "#{current_scope}_teams_path"
    when "activities_grid"
      "#{current_scope}_activities_path"
    when "submissions_grid"
      "#{current_scope}_team_submissions_path"
    when "judges_grid"
      "#{current_scope}_judges_path"
    when "scores_grid", "scored_submissions_grid"
      "#{current_scope}_scores_path"
    else
      raise "Param root #{@saved_search.param_root} not supported"
    end

    redirect_to send(path_name,
      @saved_search.param_root => @saved_search.to_search_params)
  end

  def create
    @saved_search = current_profile.saved_searches.build(saved_search_params)

    if @saved_search.save
      render partial: "saved_searches/saved_search",
        formats: [:html],
        locals: {
          saved_search: @saved_search,
          param_root: @saved_search.param_root,
          params: {
            @saved_search.param_root => @saved_search.to_search_params
          }
        }
    else
      render json: @saved_search.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @saved_search = current_profile.saved_searches.find(params[:id])
    @saved_search.destroy
    render json: {}
  end

  private

  def saved_search_params
    params.require(:saved_search).permit(:name, :param_root, :search_string)
  end
end
