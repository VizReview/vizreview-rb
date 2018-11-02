require 'thread'
require 'digest'

module VizReview
  module Service
    class GoogleUploader
      def initialize(conn = Connection.new)
        @conn = conn
      end

      def upload(url, image_path)
        image_file = File.open(image_path, 'rb')
        image = image_file.read
        md5 = Digest::MD5.base64digest(image)

        Logger.debug("GoogleUploader: Uploading image #{url} (md5: #{md5}, file_size: #{image_file.size})")
        res = conn.put(url, body: image, headers: {
          'Content-Type' => 'image/png',
          'Content-MD5' => md5,
          'Content-Length' => image_file.size.to_s,
        })
        if res.response_code == 200
          Logger.debug("GoogleUploader: Uploaded image #{url}")
        else
          Logger.debug("GoogleUploader: Failed to upload image #{url} (#{res.response_code}) #{res.body}")
        end
      end

      private

      attr_reader :conn
    end
  end
end
