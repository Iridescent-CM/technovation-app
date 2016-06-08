require "rails_helper"

class DivisionCreateTest < Minitest::Test
  def test_division_persisted
    division = Division::Create.(division: { name: :high_school }).model
    assert division.persisted?
  end

  def test_division_name_required
    _, op = Division::Create.run(division: { name: "" })
    assert op.contract.errors.keys.include?(:name)
    assert op.contract.errors[:name].include?("can't be blank")
  end

  def test_division_name_must_be_unique
    Division::Create.(division: { name: :high_school })
    _, op = Division::Create.run(division: { name: :high_school })
    assert op.contract.errors.keys.include?(:name)
    assert op.contract.errors[:name].include?("has already been taken")
  end

  def test_division_name_must_be_in_list
    _, op = Division::Create.run(division: { name: "not in list" })
    assert op.contract.errors.keys.include?(:name)
    assert op.contract.errors[:name].include?("is not included in the list")
  end
end
