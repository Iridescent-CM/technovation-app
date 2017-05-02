module MentorSearchesController
  extend ActiveSupport::Concern

  def new
    params[:nearby] = user.address_details if params[:nearby].blank?
    params[:needs_team] = false if params[:needs_team].blank? || params[:on_team] == "1"
    params[:on_team] = false if params[:on_team].blank? || params[:needs_team] == "1"
    params[:virtual_only] = false if params[:virtual_only].blank?
    params[:gender_identities] = Account.genders.values if params[:gender_identities].blank?

    @search_filter = SearchFilter.new(search_filter_params)
    @expertises = Expertise.all
    @gender_identities = { "Female" => Account.genders['Female'], "Male" => Account.genders['Male'] }
    @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
  end

  private
  def search_filter_params
    search_params = params.to_unsafe_h

    default_params = ActionController::Parameters.new({
      nearby: search_params.fetch(:nearby),
      user: user,
      needs_team: search_params.fetch(:needs_team),
      on_team: search_params.fetch(:on_team),
      virtual_only: search_params.fetch(:virtual_only),
      text: search_params.fetch(:text) { "" },
      gender_identities: search_params.fetch(:gender_identities),
    })

    default_params.merge(search_params.fetch(:search_filter) { {} })
  end

  def user
    raise "Not implemented"
  end
end
