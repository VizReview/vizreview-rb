module VizReview
  module Service
    class Version
      def initialize(conn)
        @conn = conn
      end

      def create(branch)
        Logger.debug("Creating new version from branch #{branch}...")
        conn.post('/versions/', body: { branch: branch })
      end

      def complete(id)
        Logger.debug("Marking version #{id} as complete...")
        conn.put("/versions/#{id}/complete")
      end

      private

      attr_reader :conn
    end
  end
end
