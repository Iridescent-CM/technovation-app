require "rails_helper"

class DivisionCreateHighSchoolTest < Minitest::Test
  def test_high_school_division_persisted
    hs = Division::CreateHighSchool.({}).model
    assert hs.persisted?
    assert hs.name == "high_school"
  end
end
