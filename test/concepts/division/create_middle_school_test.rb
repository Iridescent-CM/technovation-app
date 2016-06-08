require "rails_helper"

class DivisionCreateMiddleSchoolTest < Minitest::Test
  def test_middle_school_division_persisted
    ms = Division::CreateMiddleSchool.({}).model
    assert ms.persisted?
    assert ms.name == "middle_school"
  end
end
