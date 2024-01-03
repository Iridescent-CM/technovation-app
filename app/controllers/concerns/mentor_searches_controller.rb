module MentorSearchesController
  extend ActiveSupport::Concern

  def new
    @search_filter = SearchFilter.new(search_params)

    @expertises = Expertise.all

    @mentors = SearchMentors.call(@search_filter)
      .paginate(page: search_params[:page])
  end

  private

  def search_params
    params.permit(
      :utf8,
      :page,
      :nearby,
      :needs_team,
      :female_only,
      :virtual_only,
      :text,
      search_filter: {
        expertise_ids: []
      }
    ).tap do |h|
      if h[:nearby].blank?
        params[:nearby] = h[:nearby] = current_account.address_details
      end

      if h[:needs_team].blank?
        params[:needs_team] = h[:needs_team] = "-1"
      end

      if h[:female_only].blank?
        params[:female_only] = h[:female_only] = "0"
      end

      if h[:virtual_only].blank?
        params[:virtual_only] = h[:virtual_only] = false
      end

      params[:search_filter] ||=
        h[:search_filter] ||=
          {expertise_ids: []}

      if h[:search_filter][:expertise_ids].blank?
        params[:search_filter][:expertise_ids] =
          h[:search_filter][:expertise_ids] = []
      end

      if current_scope == "mentor"
        h[:mentor_account_id] = current_account.id
      end

      h[:country] = current_account.country
      h[:location] = current_account.address_details
      h[:coordinates] = current_account.coordinates
    end
  end
end
