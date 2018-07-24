class MailgunResponseSerializer
  include FastJsonapi::ObjectSerializer

  attributes :is_valid, :is_taken

  attribute(:mailbox_verification) do |response|
    response.mailbox_verification === 'true'
  end
end