require 'typhoeus'
require 'json'

module VizReview
  module Service
    class Connection
      def initialize(auth: nil)
        @auth = auth
      end

      def post(url, body: nil, headers: {}, verbose: false)
        Logger.debug("POST #{url} - #{{ body: body.to_s[0..255], headers: headers }}")
        res = Typhoeus.post(url, body: body, headers: headers.merge(auth_headers), verbose: verbose)
        Logger.debug("Response (POST #{url}): { response_code: #{res.response_code}, body: #{res.body} }")
        res
      end

      def put(url, body: nil, headers: {}, verbose: false)
        Logger.debug("PUT #{url} - #{{ body: body.to_s[0..255], headers: headers }}")
        res = Typhoeus.put(url, body: body, headers: headers.merge(auth_headers), verbose: verbose)
        Logger.debug("Response (PUT #{url}): { response_code: #{res.response_code}, body: #{res.body} }")
        res
      end

      private

      attr_reader :auth

      def auth_headers
        auth&.headers || {}
      end
    end
  end
end
