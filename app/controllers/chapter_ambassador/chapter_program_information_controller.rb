module ChapterAmbassador
  class ChapterProgramInformationController < ChapterAmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    def new
      @chapter_program_information = current_chapter.build_chapter_program_information
    end

    def create
      @chapter_program_information = current_chapter.build_chapter_program_information(chapter_program_information_params)

      if @chapter_program_information.save
        redirect_to chapter_ambassador_chapter_program_information_path,
          success: "You updated your chapter program information!"
      else
        flash.now[:alert] = "Error updating chapter program information."
        render :new
      end
    end

    def edit
      @chapter_program_information = current_chapter.chapter_program_information
    end

    def update
      @chapter_program_information = current_chapter.chapter_program_information

      if @chapter_program_information.update(chapter_program_information_params)
        redirect_to chapter_ambassador_chapter_program_information_path,
          success: "You updated your chapter program information!"
      else
        flash.now[:alert] = "Error updating chapter program information."
        render :edit
      end
    end

    private

    def chapter_program_information_params
      params.require(:chapter_program_information).permit(
        :child_safeguarding_policy_and_process,
        :team_structure,
        :external_partnerships,
        :start_date,
        :launch_date,
        :program_model,
        :number_of_low_income_or_underserved_calculation,
        :program_length_id,
        :participant_count_estimate_id,
        :low_income_estimate_id,
        organization_type_ids: [],
        meeting_time_ids: [],
        meeting_facilitator_ids: []
      )
    end
  end
end
