require "rails_helper"

RSpec.describe PasswordComplexityValidator do
  subject(:validator) { described_class.new(attributes: [:password]) }

  let(:record_class) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :password, :email

      validates :password, password_complexity: true
    end
  end

  let(:record) { record_class.new(email: "personxyz@example.com") }

  def validate(password)
    record.password = password
    record.valid?
  end

  it "accepts a password with upper, lower, and digit" do
    expect(validate("Secret1234")).to be(true)
    expect(record.errors[:password]).to be_empty
  end

  it "rejects passwords without an uppercase letter" do
    expect(validate("secret1234")).to be(false)
    expect(record.errors.details[:password]).to include(error: :missing_uppercase)
  end

  it "rejects passwords without a lowercase letter" do
    expect(validate("SECRET1234")).to be(false)
    expect(record.errors.details[:password]).to include(error: :missing_lowercase)
  end

  it "rejects passwords without a digit" do
    expect(validate("Secretabcd")).to be(false)
    expect(record.errors.details[:password]).to include(error: :missing_digit)
  end

  it "rejects passwords containing the email local-part" do
    expect(validate("PersonxyzSecret1")).to be(false)
    expect(record.errors.details[:password]).to include(error: :contains_email_local_part)
  end

  it "skips validation when password is blank" do
    expect(validate("")).to be(true)
    expect(record.errors[:password]).to be_empty
  end
end
