module MentorSearchesController
  extend ActiveSupport::Concern

  def new
    params[:nearby] = user.address_details if params[:nearby].blank?
    params[:needs_team] = false if params[:needs_team].blank?
    params[:virtual_only] = false if params[:virtual_only].blank?

    @search_filter = SearchFilter.new(search_filter_params)
    @expertises = Expertise.all
    @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
  end

  private
  def search_filter_params
    params.fetch(:search_filter) { {} }.merge({
      nearby: params.fetch(:nearby),
      user: user,
      needs_team: params.fetch(:needs_team),
      virtual_only: params.fetch(:virtual_only),
      text: params.fetch(:text) { "" },
      page: params[:page],
      per_page: 15,
    })
  end

  def user
    raise "Not implemented"
  end
end
