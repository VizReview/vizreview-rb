module VizReview
  class Client
    API_URL = 'https://us-central1-vizreview-dev.cloudfunctions.net'

    class << self
      attr_reader :config, :conn, :version_service, :version_id, :uploader,
        :snapshot_service, :version_info_provider

      def start
        Logger.prefix = 'VizReview - '
        @config = default_config
        yield(config) if block_given?
        Logger.level = config.log_level
        raise 'Token not provided in VizReview::Client.start block' if config.token.nil?
        auth = Service::Auth.new(config.token)
        @conn = Service::APIConnection.new(url: config.api_url, auth: auth)
        @version_info_provider = VersionInfoProviders::ProviderDetector.retrieve
        @version_service = Service::Version.new(conn)
        @uploader = Service::ParallelUploader.new(pool_size: 4)
        @snapshot_service = Service::Snapshot.new(conn)
        initiate_version!
      end

      def finish
        raise 'VizReview client has not been started.' if version_id.nil?
        uploader&.stop
        version_service&.complete(version_id)
      end

      def capture!(driver, name:, viewport: nil)
        raise 'VizReview client has not been started.' if version_id.nil?
        viewport = config.default_viewport if viewport.nil?
        viewport = [viewport] unless viewport.is_a?(Array)
        driver = driver.driver if driver.respond_to?(:driver)
        info_provider = Browser::InfoProvider.new(driver)
        page_manager = Browser::PageManager.new(driver)
        screenshot_provider = ScreenshotProvider.new(page_manager, info_provider)

        # For each viewport, take a screenshot
        snapshots = []
        viewport.each do |vp|
          snapshots << screenshot_provider.snap!(full: true, viewport: vp)
        end

        snapshots.each { |snapshot| upload_snapshot(name, snapshot) }
      end

      private

      def initiate_version!
        branch = version_info_provider.branch
        version = version_service.create(branch)
        @version_id = JSON.parse(version.body)['id']
      end

      def upload_snapshot(name, snapshot)
        tmp = snapshot.image.save_temp
        result = snapshot_service.create(version_id, snapshot: snapshot, name: name)
        upload_url = JSON.parse(result.body)['uploadUrl']
        uploader.upload(upload_url, tmp.path)
      end

      def default_config
        Configuration.new(api_url: API_URL)
      end
    end
  end
end
