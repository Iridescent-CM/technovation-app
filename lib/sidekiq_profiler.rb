require "objspace"
require "tempfile"

class HeapDumpUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "heap_dumps"
  end
end

module Sidekiq
  module Middleware
    module Server
      class Profiler

        # Number of jobs to process before reporting
        JOBS = ENV.fetch("SIDEKIQ_PROFILER_REPORT_INCREMENT") { 100 }.to_i
        STAMP = Time.now.to_i

        class << self
          mattr_accessor :counter
          self.counter = 0

          def synchronize(&block)
            @lock ||= Mutex.new
            @lock.synchronize(&block)
          end
        end

        def call(worker_instance, item, queue)
          begin
            yield
          ensure
            self.class.synchronize do
              self.class.counter += 1

              if self.class.counter % JOBS == 0
                Sidekiq.logger.info "reporting allocations after #{self.class.counter} jobs"
                GC.start
                basename = "heap-#{STAMP}-#{self.class.counter}-"
                f = Tempfile.new([basename, '.json'])
                begin
                  ObjectSpace.dump_all(output: f)
                  Sidekiq.logger.info "heap saved to #{f.path}"
                  if ENV["UPLOAD_SIDEKIQ_HEAP_DUMPS"].present?
                    uploader = HeapDumpUploader.new
                    uploader.store!(f)
                    Sidekiq.logger.info "heap uploaded to #{uploader.url}"
                  end
                ensure
                  f.close
                  f.unlink
                end
              end
            end
          end
        end
      end
    end
  end
end
