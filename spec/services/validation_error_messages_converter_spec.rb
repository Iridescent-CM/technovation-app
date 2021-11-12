require "rails_helper"

describe ValidationErrorMessagesConverter do
  let(:validation_error_messages_converter) {
    ValidationErrorMessagesConverter.new(errors: errors, error_key_conversions: error_key_conversions)
  }
  let(:errors) { [error1, error2] }
  let(:error1) { double("EmailValidationError", attribute: "account.email", message: "is invalid") }
  let(:error2) { double("FirstNameValidationError", attribute: "account.first_name", message: "can't be blank") }
  let(:error_key_conversions) {
    {
      "account.email": "accountEmail",
      "account.first_name": "accountFirstName"
    }
  }

  describe "#call" do
    let(:expectedErrorsWithConvertedKeys) {
      {
        "accountEmail" => "is invalid",
        "accountFirstName" => "can't be blank"
      }
    }

    it "returns the original error messages with converted keys based on 'error_key_conversions'" do
      expect(validation_error_messages_converter.call).to eq(expectedErrorsWithConvertedKeys)
    end

    context "when the error key is not in 'error_key_conversions'" do
      let(:errors) { [double("ARandomValidationError", attribute: "originalKey", message: "is invalid")] }
      let(:error_key_conversions) { {} }

      it "returns the original error message with the original key" do
        expect(validation_error_messages_converter.call).to eq({"originalKey" => "is invalid"})
      end
    end
  end
end
