module VizReview
  module Service
    class Auth
      def initialize(token)
        @token = token
      end

      def headers
        { 'Authorization' => "Bearer #{token}" }
      end

      private

      attr_reader :token
    end
  end
end
