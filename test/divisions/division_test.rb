require "rails_helper"

class DivisionTest < Minitest::Test
  def test_high_school_division
    assert Division.high_school.name == "high_school"
  end
end
