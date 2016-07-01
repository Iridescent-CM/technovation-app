require "rails_helper"

class AccountsTest < Minitest::Test
  def test_creates_auth_token
    account = Account.create(account_attributes)
    refute account.auth_token.blank?
  end

  def test_doesnt_create_duplicate_auth_token
    secure_random = MiniTest::Mock.new
    GenerateToken.stub(:token_generator, secure_random) do

      secure_random.expect(:urlsafe_base64, "abc123")
      Account.create(account_attributes)

      secure_random.expect(:urlsafe_base64, "abc123")
      secure_random.expect(:urlsafe_base64, "123abc")
      other = Account.create(account_attributes(email: "other@example.com"))

      assert_equal "123abc", other.auth_token
    end
  end
end
