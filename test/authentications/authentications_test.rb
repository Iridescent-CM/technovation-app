require "rails_helper"

class AuthenticationsTest < Minitest::Test
  def test_creates_auth_token
    auth = CreateAuthentication.(auth_attributes)
    refute auth.auth_token.blank?
  end

  def test_doesnt_create_duplicate_auth_token
    secure_random = MiniTest::Mock.new
    GenerateToken.stub(:token_generator, secure_random) do

      secure_random.expect(:urlsafe_base64, "abc123")
      CreateAuthentication.(auth_attributes)

      secure_random.expect(:urlsafe_base64, "abc123")
      secure_random.expect(:urlsafe_base64, "123abc")
      other = CreateAuthentication.(auth_attributes(email: "other@example.com"))

      assert_equal "123abc", other.auth_token
    end
  end
end
