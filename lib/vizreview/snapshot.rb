module VizReview
  class Snapshot
    attr_reader :image, :browser, :viewport

    def initialize(image:, browser:, viewport:)
      @image = image
      @browser = browser
      @viewport = viewport
    end
  end
end
