module GuidanceProfileSignup
  extend ActiveSupport::Concern

  included do
    before_filter :expertises
  end

  private
  def profile_params
    [
      :school_company_name,
      :job_title,
      { expertise_ids: [] },
    ]
  end

  def expertises
    @expertises ||= Expertise.all
  end
end
