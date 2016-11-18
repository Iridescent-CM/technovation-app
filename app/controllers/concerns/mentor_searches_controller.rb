module MentorSearchesController
  extend ActiveSupport::Concern

  def new
    params[:nearby] = user.address_details if params[:nearby].blank?
    params[:needs_team] = false if params[:needs_team].blank?
    params[:virtual_only] = false if params[:virtual_only].blank?
    params[:gender_identities] = Account.genders.values if params[:gender_identities].blank?

    @search_filter = SearchFilter.new(search_filter_params)
    @expertises = Expertise.all
    @gender_identities = { "Female" => Account.genders['Female'], "Male" => Account.genders['Male'] }
    @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
  end

  private
  def search_filter_params
    default_params = {
      nearby: params.fetch(:nearby),
      user: user,
      needs_team: params.fetch(:needs_team),
      virtual_only: params.fetch(:virtual_only),
      text: params.fetch(:text) { "" },
      gender_identities: params.fetch(:gender_identities),
    }

    default_params.merge(params.fetch(:search_filter) { {} }.symbolize_keys)
  end

  def user
    raise "Not implemented"
  end
end
