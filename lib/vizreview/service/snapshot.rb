require 'digest'

module VizReview
  module Service
    class Snapshot
      def initialize(conn)
        @conn = conn
      end

      def create(version_id, snapshot:, name:)
        md5 = Digest::MD5.base64digest(snapshot.image.to_blob)
        conn.post('/snapshots/', body: {
          versionId: version_id,
          name: name,
          width: snapshot.image.width,
          height: snapshot.image.height,
          viewport: snapshot.viewport,
          browser: snapshot.browser,
          contentType: 'image/png',
          contentMd5: md5
        })
      end

      def complete(id)
        conn.put("/versions/#{id}/complete", body: { branch: branch })
      end

      private

      attr_reader :conn
    end
  end
end
