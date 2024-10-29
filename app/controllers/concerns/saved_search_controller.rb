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
    when "mentors_grid"
      "#{current_scope}_mentors_path"
    when "scores_grid"
      "#{current_scope}_score_exports_path"
    when "scored_submissions_grid"
      "#{current_scope}_scores_path"
    when "chapters_grid"
      "#{current_scope}_chapters_path"
    when "chapter_ambassadors_grid"
      "#{current_scope}_chapter_ambassadors_path"
    when "parental_consents_grid"
      "#{current_scope}_paper_parental_consents_path"
    when "legal_documents_grid"
      "admin_legal_documents_path"
    when "unaffiliated_students_grid"
      "#{current_scope}_unaffiliated_students_path"
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
