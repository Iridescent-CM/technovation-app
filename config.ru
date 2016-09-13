# This file is used by Rack-based servers to start the application.

class PumaOOBGC
  def initialize(app, frequency, logger=nil)
    @app           = app
    @frequency     = frequency
    @logger        = logger
    @request_count = 0
    @mutex         = Mutex.new
  end

  def call(env)
    status, header, body = @app.call(env)

    if ary = env['rack.after_reply']
      ary << lambda {maybe_perform_gc}
    end
    [status, header, body]
  end

  def maybe_perform_gc
    @mutex.synchronize do
      @request_count += 1
      if @request_count == @frequency
        @request_count = 0
        t0 = Time.now
        disabled = GC.enable
        GC.start
        GC.disable if disabled
        @logger.debug "[OOBGC] [#{Process.pid}] Finished GC in #{Time.now - t0} sec" if @logger
      end
    end
  end
end

require ::File.expand_path('../config/environment', __FILE__)
use PumaOOBGC, 10, Rails.logger
run Rails.application
