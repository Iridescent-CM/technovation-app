module DatagridUser
  extend ActiveSupport::Concern

  included do
    helper_method :default_or_saved_search_params?

    before_action -> {
      @saved_searches = current_profile.saved_searches
        .for_param_root(:accounts_grid)

      @saved_search = current_profile.saved_searches.build
    }, only: :index
  end

  private
  def detect_extra_columns
    columns = Array(params[:accounts_grid][:column_names])

    if Array(params[:accounts_grid][:country]).any?
      columns << :country
    end

    if Array(params[:accounts_grid][:state_province]).any?
      columns << :state_province
    end

    if Array(params[:accounts_grid][:city]).any?
      columns << :city
    end

    columns
  end

  def default_or_saved_search_params?
    SavedSearch.default_or_saved_search_params?(params, current_profile)
  end
end
