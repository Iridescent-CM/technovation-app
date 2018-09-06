module MailgunHelper
  def stub_mailgun_validation(valid:, email:)
    allow(HTTParty).to receive(:get).and_return({
      "address" => email,
      "did_you_mean" => nil,
      "is_disposable_address" => false,
      "is_role_address" => true,
      "is_valid" => valid,
      "mailbox_verification" => "true",
      "parts" => {
          "display_name" => nil,
          "domain" => email.split("@")[1],
          "local_part" => email.split("@")[0],
      }
    })
  end
end