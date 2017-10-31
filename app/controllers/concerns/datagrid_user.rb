module DatagridUser
  extend ActiveSupport::Concern

  included do
    helper_method :default_or_saved_search_params?,
      :param_root

    before_action -> {
      @saved_searches = current_profile.saved_searches
        .for_param_root(param_root)

      @saved_search = current_profile.saved_searches.build
    }, only: :index
  end

  private
  def detect_extra_columns(grid_params)
    columns = Array(grid_params[:column_names]).flatten.map(&:to_sym)

    if Array(grid_params[:country]).many?
      columns = columns | [:country]
    end

    if not Array(grid_params[:state_province]).one? and
        (Array(grid_params[:state_province]).many? or
          Array(grid_params[:country]).one?)
      columns = columns | [:state_province]
    end

    if Array(grid_params[:city]).any? or
        Array(grid_params[:state_province]).one?
      columns = columns | [:city]
    end

    if Array(grid_params[:profile_type]).many? or
        grid_params[:team_matching].present?
      columns = columns | [:profile_type]
    end

    columns
  end

  def default_or_saved_search_params?
    SavedSearch.default_or_saved_search_params?(params, param_root, current_profile)
  end

  def param_root
    raise "Your controller must define the `#param_root` method"
  end
end
