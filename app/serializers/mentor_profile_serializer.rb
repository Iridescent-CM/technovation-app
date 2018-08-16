class MentorProfileSerializer
  include FastJsonapi::ObjectSerializer

  attributes :school_company_name, :job_title
end