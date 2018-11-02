module VizReview
  class Rectangle
    OVERLAP = 4

    attr_reader :x, :y, :width, :height

    def initialize(x, y, width, height)
      @x = x
      @y = y
      @width = width
      @height = height
    end

    def subdivide(sub_width, sub_height)
      rects = []
      top = x
      while (top < height)
        bottom = [top + sub_height, height].min
        left = y
        while (left < width)
          right = [left + sub_width, width].min
          rects << Rectangle.new(
            right - sub_width,
            bottom - sub_height,
            sub_width,
            sub_height,
          )
          left += sub_width
        end
        top += sub_height
      end
      rects
    end
  end
end
