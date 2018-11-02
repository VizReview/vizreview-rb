module VizReview
  module VersionInfoProviders
    class ProviderDetector
      class << self
        def retrieve
          GitProvider.new
        end
      end
    end
  end
end
