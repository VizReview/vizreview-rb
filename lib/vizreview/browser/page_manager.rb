module VizReview
  module Browser
    class PageManager
      def initialize(driver)
        @driver = driver
      end

      def screenshot
        # currOverflow = scrollOverflow
        # scrollOverflow = 'hidden' if hideScrollbars
        img = driver.browser.screenshot_as(:png)
        # scrollOverflow = currOverflow
        Image.from_string(img)
      end

      def scroll_to(x, y)
        driver.execute_script("window.scrollTo(#{x}, #{y})")
      end

      def hide_scrollbars
        res = overflow = scroll_overflow
        driver.execute_script('document.querySelector("html").style.overflow = "hidden";')
        res = yield if block_given?
        driver.execute_script("document.querySelector(\"html\").style.overflow = \"#{overflow}\";")
        res
      end

      def apply_viewport(viewport)
        curr_size = driver.browser.manage.window.size
        return yield(curr_size.width, curr_size.height) if viewport.nil?
        driver.browser.manage.window.resize_to(
          viewport[:width] || curr_size.width, viewport[:height] || curr_size.height
        )
        new_size = driver.browser.manage.window.size
        res = yield(new_size.width, new_size.height)
        driver.browser.manage.window.resize_to(curr_size.width, curr_size.height)
        res
      end

      private

      attr_reader :driver

      def scroll_overflow
        driver.execute_script('return document.querySelector("html").style.overflow;')
      end
    end
  end
end
