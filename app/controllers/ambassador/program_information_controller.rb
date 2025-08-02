module Ambassador
  class ProgramInformationController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded
    layout :set_layout_for_current_ambassador

    def new
      @program_information = current_chapterable.build_program_information
    end

    def create
      @program_information = current_chapterable.build_program_information(program_information_params)

      if @program_information.save
        redirect_to send(:"#{current_scope}_program_information_path"),
          success: "You updated your #{current_scope.titleize} program information!"
      else
        flash.now[:alert] = "Error updating #{current_scope.titleize} program information."
        render :new
      end
    end

    def edit
      @program_information = current_chapterable.program_information
    end

    def update
      @program_information = current_chapterable.program_information

      if @program_information.update(program_information_params)
        redirect_to send(:"#{current_scope}_program_information_path"),
          success: "You updated your #{current_scope.titleize} program information!"
      else
        flash.now[:alert] = "Error updating #{current_scope.titleize} program information."
        render :edit
      end
    end

    private

    def program_information_params
      params.require(:program_information).permit(
        :child_safeguarding_policy_and_process,
        :start_date,
        :work_related_ambassador,
        :program_length_id,
        organization_type_ids: [],
        meeting_time_ids: [],
        meeting_facilitator_ids: [],
        meeting_format_ids: []
      )
    end
  end
end
