require "rails_helper"

describe ValidationErrorMessagesConverter do
  let(:validation_error_messages_converter) {
    ValidationErrorMessagesConverter.new(errors: errors, error_key_conversions: error_key_conversions)
  }
  let(:errors) { [] }
  let(:error_key_conversions) { {} }

  describe "#individual_errors" do
    let(:errors) { [error1, error2] }
    let(:error1) { double("EmailValidationError", attribute: "account.email", message: "is invalid") }
    let(:error2) { double("FirstNameValidationError", attribute: "account.first_name", message: "can't be blank") }
    let(:error_key_conversions) {
      {
        "account.email": "accountEmail",
        "account.first_name": "accountFirstName"
      }
    }

    let(:expected_errrors_with_converted_keys) {
      {
        "accountEmail" => ["is invalid"],
        "accountFirstName" => ["can't be blank"]
      }
    }

    it "returns the original error messages with converted keys based on 'error_key_conversions'" do
      expect(validation_error_messages_converter.individual_errors).to eq(expected_errrors_with_converted_keys)
    end

    context "when the error key is not in 'error_key_conversions'" do
      let(:errors) { [double("ARandomValidationError", attribute: "originalKey", message: "is invalid")] }
      let(:error_key_conversions) { {} }

      it "returns the original error message with the original key" do
        expect(validation_error_messages_converter.individual_errors).to eq({"originalKey" => ["is invalid"]})
      end
    end

    context "when there is more than one error for the same error key" do
      let(:errors) { [error1, error2] }
      let(:error1) { double("EmailValidationError1", attribute: "account.email", message: "is invalid") }
      let(:error2) { double("EmailValidationError1", attribute: "account.email", message: "wrong format") }
      let(:error_key_conversions) { {} }

      let(:expected_errrors_with_converted_keys) {
        {
          "account.email" => ["is invalid", "wrong format"]
        }
      }

      it "returns all the errors for the error key" do
        expect(validation_error_messages_converter.individual_errors).to eq(expected_errrors_with_converted_keys)
      end
    end
  end

  describe "#full_errors" do
    let(:errors) { double("errors", full_messages: ["First name can't be blank"]) }

    it "includes a general 'something went wrong' error message" do
      expect(validation_error_messages_converter.full_errors)
        .to include("Something went wrong saving your profile")
    end

    it "includes the original error message" do
      expect(validation_error_messages_converter.full_errors)
        .to include("First name can't be blank")
    end

    context "when the error message includes 'Account is invalid'" do
      let(:errors) { double("errors", full_messages: ["Account is invalid"]) }

      it "removes it from the error messages" do
        expect(validation_error_messages_converter.full_errors).not_to include("Account is invalid")
      end
    end

    context "when the error message includes 'Mentor profile expertises is invalid'" do
      let(:errors) { double("errors", full_messages: ["Mentor profile expertises is invalid"]) }

      it "removes it from the error messages" do
        expect(validation_error_messages_converter.full_errors).not_to include("Mentor profile expertises is invalid")
      end
    end
  end
end
