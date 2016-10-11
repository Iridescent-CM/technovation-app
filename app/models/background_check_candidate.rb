class BackgroundCheckCandidate
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :first_name, :middle_name, :last_name,
    :email, :zipcode, :date_of_birth, :ssn, :driver_license_state,
    :id, :report_id, :candidate

  validates :first_name, :last_name, :email, :zipcode, :date_of_birth, :ssn,
    :driver_license_state, presence: true

  validates :driver_license_state, length: { minimum: 2, maximum: 2 }, format: { with: /\A[a-zA-Z]{2}\z/ }

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
    @candidate = BackgroundCheck::Candidate.new(attributes)
    if valid?
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
  end

  private
  def attributes
    Hash[{
           "first_name" => @first_name,
           "middle_name" => @middle_name,
           "last_name" => @last_name,
           "email" => @email,
           "zipcode" => @zipcode,
           "dob" => @date_of_birth,
           "ssn" => @ssn,
           "driver_license_state" => @driver_license_state,
         }.map { |k, v| [k, (v || "").strip] }]
  end

  def apply_errors(field_names)
    field_names.each do |name|
      if name == "State cannot be empty is not a valid US state" or
          name.include?("is not a valid US state")
        errors.add(:driver_license_state, :invalid)
      elsif name.include?("must have SSN")
        errors.add(:ssn, :blank)
      elsif name.include?("must be at least 18 year old")
        errors.add(:date_of_birth, "You must be at least 18 years old")
      else
        errors.add(name.downcase, :invalid)
      end
    end
  end
end
