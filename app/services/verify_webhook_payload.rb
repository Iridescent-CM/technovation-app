class VerifyWebhookPayload
  def initialize(
    payload:,
    secret:,
    signature:,
    digest_type: OpenSSL::Digest.new("sha256"),
    logger: Rails.logger,
    error_notifier: Airbrake
  )

    @payload = payload
    @secret = secret
    @signature = signature
    @digest_type = digest_type
    @logger = logger
    @error_notifier = error_notifier
  end

  def call
    if valid_payload?
      Result.new(success?: true)
    else
      error = "[WEBHOOK PAYLOAD] Error verifying payload: #{payload}"

      logger.error(error)
      error_notifier.notify(error)

      Result.new(success?: false, message: error)
    end
  end

  private

  attr_reader :payload, :secret, :signature, :digest_type, :logger, :error_notifier

  Result = Struct.new(:success?, :message, keyword_init: true)

  def valid_payload?
    OpenSSL.secure_compare(hmac_calculation_from_payload, signature)
  end

  def hmac_calculation_from_payload
    Base64.encode64(
      OpenSSL::HMAC.digest(
        digest_type,
        secret,
        payload
      )
    ).chomp
  end
end
