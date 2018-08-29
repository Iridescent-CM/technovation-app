class MailgunResponseSerializer
  include FastJsonapi::ObjectSerializer

  attributes :address, :did_you_mean, :is_disposable_address,
    :is_role_address, :is_valid, :parts, :is_taken

  attribute(:mailbox_verification) do |response|
    if response.mailbox_verification.nil?
      nil
    else
      response.mailbox_verification === 'true'
    end
  end
end