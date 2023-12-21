class SpoofIp
  def initialize(app, ip)
    @app = app
    @ip = ip
  end

  def call(env)
    env["REMOTE_ADDR"] = @ip
    env["action_dispatch.remote_ip"] = @ip

    Rails.logger.info(["[SPOOFING IP]", @ip].join(" "))

    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end
