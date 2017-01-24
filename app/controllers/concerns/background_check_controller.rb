module BackgroundCheckController
  def new
    if current_profile.background_check_candidate_id.present?
      redirect_to [current_account.type_name, :background_check, id: current_profile.background_check_candidate_id]
    else
      @candidate = BackgroundCheckCandidate.new(account: current_account)
    end
  end

  def show
    @report = BackgroundCheck::Report.retrieve(current_profile.background_check_report_id)

    if @report.present?
      current_profile.background_check.send("#{@report.status}!")
    end
  end

  def create
    @candidate = BackgroundCheckCandidate.new(candidate_params)

    if @candidate.submit
      current_profile.update_attributes(background_check_attributes: {
        candidate_id: @candidate.id,
        report_id: @candidate.report_id
      })
      redirect_to [current_account.type_name, :dashboard],
        success: "Thank you for submitting your background check."
    else
      render :new
    end
  end

  private
  def candidate_params
    params.require(:background_check_candidate)
      .permit(:first_name, :middle_name, :last_name, :email, :zipcode,
    :date_of_birth, :ssn, :driver_license_state, :copy_requested).tap do |tapped|
        tapped[:driver_license_state] = tapped[:driver_license_state].strip
      end
  end
end
