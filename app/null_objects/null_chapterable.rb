class NullChapterable < NullObject
  def name
    nil
  end

  def summary
    nil
  end

  def primary_contact
    nil
  end

  def program_information
    ProgramInformation.none
  end

  def build_program_information
    ProgramInformation.none
  end

  def country
    nil
  end

  def country_code
    nil
  end
end
