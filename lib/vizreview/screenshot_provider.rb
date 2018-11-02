module VizReview
  class ScreenshotProvider
    def initialize(page, info_provider)
      @page = page
      @info_provider = info_provider
    end

    def snap!(full: true, viewport: nil)
      page.hide_scrollbars do
        page.apply_viewport(viewport) do |width, height|
          img = full ? full_snap! : page.screenshot
          Snapshot.new(
            image: img,
            viewport: { width: width, height: height },
            browser: {
              name: info_provider.browser_name,
              version: nil,
            },
          )
        end
      end
    end

    private

    def full_snap!
      ratio = info_provider.pixel_ratio
      rect = info_provider.page_rect

      img = page.screenshot
      sub_width = (img.width / ratio).round
      sub_height = (img.height / ratio).round

      base = Image.create(rect.width * ratio, rect.height * ratio)

      rect.subdivide(sub_width, sub_height).each do |subrect|
        page.scroll_to(subrect.x, subrect.y)
        img = page.screenshot
        base.draw!(img, subrect.x * ratio, subrect.y * ratio)
      end
      base
    end

    attr_reader :page, :info_provider
  end
end
