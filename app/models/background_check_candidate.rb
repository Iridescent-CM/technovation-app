class BackgroundCheckCandidate
  include ActiveModel::Model

  attr_accessor :first_name, :middle_name, :last_name,
    :email, :phone, :zipcode, :date_of_birth, :ssn,
    :driver_license_state, :driver_license_number,
    :id, :report_id

  def initialize(attributes = {})
    account = attributes.delete(:account)

    super

    if !!account
      @first_name = account.first_name
      @last_name = account.last_name
      @email = account.email
      @date_of_birth = account.date_of_birth
    end
  end

  def submit
    candidate = BackgroundCheck::Candidate.new(attributes)
    begin
      candidate.submit
      report = BackgroundCheck::Report.new(candidate_id: candidate.id)
      report.submit
      @id = candidate.id
      @report_id = report.id
      true
    rescue Checkr::InvalidRequestError => e
      invalid_fields = e.message.split(' is invalid').map { |s| s.gsub(', ', '') }
      apply_errors(invalid_fields)
      false
    end
  end

  private
  def attributes
    Hash[{
           "first_name" => @first_name,
           "middle_name" => @middle_name,
           "last_name" => @last_name,
           "email" => @email,
           "phone" => @phone,
           "zipcode" => @zipcode,
           "dob" => @date_of_birth,
           "ssn" => @ssn,
           "driver_license_state" => @driver_license_state,
           "driver_license_number" => @driver_license_number,
         }.map { |k, v| [k, (v || "").strip] }]
  end

  def apply_errors(field_names)
    field_names.each do |name|
      if name == "State cannot be empty is not a valid US state" or
          name.include?("is not a valid US state")
        errors.add(:driver_license_state, :invalid)
      elsif name.downcase.include?("driver's license number must only contain")
        errors.add(:driver_license_number, :invalid)
      elsif name.include?("must have SSN")
        errors.add(:ssn, :blank)
      else
        errors.add(name.downcase, :invalid)
      end
    end
  end
end
