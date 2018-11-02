module VizReview
  module VersionInfoProviders
    class GitProvider
      def initialize
        raise 'Git must be initialized in the project' unless Utils::GitUtils.installed?
      end

      def branch
        Utils::GitUtils.branch
      end
    end
  end
end
