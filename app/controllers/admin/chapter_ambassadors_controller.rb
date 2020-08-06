module Admin
  class ChapterAmbassadorsController < AdminController
    def index
      params[:status] ||= :pending
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?

      chapter_ambassadors = Account.joins(:chapter_ambassador_profile)
        .where("chapter_ambassador_profiles.status = ?",
               ChapterAmbassadorProfile.statuses[params.fetch(:status)])

      unless params[:text].blank?
        results = chapter_ambassadors.search({
          query: {
            query_string: {
              query: params[:text]
            },
          },
          from: 0,
          size: 10_000
        }).results

        chapter_ambassadors = chapter_ambassadors.where(id: results.flat_map { |r| r._source.id })
      end

      @chapter_ambassadors = chapter_ambassadors.page(params[:page].to_i).per_page(params[:per_page].to_i)

      if @chapter_ambassadors.empty?
        @chapter_ambassadors = @chapter_ambassadors.page(1)
      end
    end

    def show
      @chapter_ambassador = ChapterAmbassadorProfile.find_by(account_id: params.fetch(:id))
      @report = BackgroundCheck::Report.retrieve(@chapter_ambassador.background_check_report_id)
      @consent_waiver = @chapter_ambassador.consent_waiver
    end

    def update
      ambassador = ChapterAmbassadorProfile.find(params.fetch(:id))
      ambassador.public_send("#{params.fetch(:status)}!")
      redirect_back fallback_location: admin_chapter_ambassadors_path,
        success: "#{ambassador.full_name} was marked as #{params.fetch(:status)}"
    end
  end
end
