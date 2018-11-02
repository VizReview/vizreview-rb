module VizReview
  module Browser
    class InfoProvider
      def initialize(driver)
        @driver = driver
      end

      def page_rect
        metrics = driver.execute_script(JS_GET_PAGE_METRICS).with_indifferent_access
        max_width = [metrics[:scroll_width], metrics[:body_scroll_width]].max
        max_height = [metrics[:body_client_height], metrics[:body_scroll_height]].max
        return Rectangle.new(0, 0, max_width, max_height)
      end

      def pixel_ratio
        driver.execute_script('return window.devicePixelRatio')
      end

      def browser_name
        driver.browser.browser
      end

      private

      attr_reader :driver

      JS_GET_PAGE_METRICS = <<-JS.freeze
        return {
          scroll_width: document.documentElement.scrollWidth,
          body_scroll_width: document.body.scrollWidth,
          client_height: document.documentElement.clientHeight,
          body_client_height: document.body.clientHeight,
          scroll_height: document.documentElement.scrollHeight,
          body_scroll_height: document.body.scrollHeight
        };
      JS
    end
  end
end
