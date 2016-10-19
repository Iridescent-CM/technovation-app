module Student
  class HonorCodeAgreementsController < StudentController
    def new
      @honor_code_agreement = current_student.build_honor_code_agreement
    end

    def create
      @honor_code_agreement = current_student.build_honor_code_agreement(honor_code_agreement_params)

      if @honor_code_agreement.save
        redirect_to student_dashboard_path,
          success: "Thank you for your promise. Now get out there and show us what you got!"
      else
        render :new
      end
    end

    private
    def honor_code_agreement_params
      params.require(:honor_code_agreement).permit(:agreement_confirmed, :electronic_signature)
    end
  end
end
