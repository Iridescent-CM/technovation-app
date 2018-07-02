
class SpoofIp
  def initialize(app, ip)
    @app = app
    @ip = ip
  end

  def call(env)
    Rails.logger.info(
      [
        "[SPOOFING IP]",
        env['REMOTE_ADDR'] = env['action_dispatch.remote_ip'] = @ip
      ].join(" ")
    )

    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end