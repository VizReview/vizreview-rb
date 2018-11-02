module VizReview
  module Service
    class APIConnection < Connection
      def initialize(url:, auth:)
        super(auth: auth)
        @url = url
      end

      def post(path, body: nil, headers: {})
        super("#{url}#{path}", body: body, headers: headers)
      end

      def put(path, body: nil, headers: {})
        super("#{url}#{path}", body: body, headers: headers)
      end

      private

      attr_reader :url
    end
  end
end
