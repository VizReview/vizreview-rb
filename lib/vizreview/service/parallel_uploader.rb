require 'thread'
require 'uri'

module VizReview
  module Service
    class ParallelUploader
      DEFAULT_POOL_SIZE = 4
      EXIT_CODE = 1

      def initialize(pool_size: DEFAULT_POOL_SIZE)
        @pool_size = pool_size
        @queue = Queue.new
        @workers = start_pool
      end

      def upload(url, image_path)
        queue.push({ url: url, image_path: image_path })
      end

      def stop
        Logger.debug("ParallelUploader: Stopping uploader pool...")
        pool_size.times { queue.push(EXIT_CODE) }
        @workers.each { |worker| worker.join }
        Logger.debug("ParallelUploader: Uploader pool completely stopped")
      end

      private

      attr_reader :pool_size, :workers, :queue

      def start_pool
        Logger.debug("ParallelUploader: Starting uploader pool (pool_size: #{pool_size})")
        (1..pool_size).map do |index|
          Logger.debug("ParallelUploader: Starting uploader thread ##{index}...")
          Thread.new do
            Logger.debug("ParallelUploader: Uploader thread ##{index} started")
            begin
              uploader = GoogleUploader.new
              while (data = @queue.pop(false))
                Logger.debug("ParallelUploader: Uploader thread ##{index} received #{data}")
                break if data == EXIT_CODE
                uploader.upload(data[:url], data[:image_path])
              end
            rescue ThreadError
            end
            Logger.debug("ParallelUploader: Uploader thread ##{index} exiting...")
          end
        end
      end
    end
  end
end
