class MailgunResponse
  attr_accessor :id, :address, :did_you_mean, :is_disposable_address,
    :is_role_address, :is_valid, :mailbox_verification, :parts, :reason,
    :is_taken, :message

  def initialize(response)
    @id = SecureRandom.hex(4)

    response.each do |key, value|
      begin
        send("#{key}=", value)
      rescue NoMethodError
        next
      end
    end
  end
end