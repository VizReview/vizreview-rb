require 'chunky_png'

module VizReview
  class Image
    class << self
      def from_string(img_str)
        stream = ::ChunkyPNG::Datastream.from_string(img_str)
        image = ::ChunkyPNG::Image.from_datastream(stream)
        new(image)
      end

      def create(width, height)
        new(::ChunkyPNG::Image.new(width, height))
      end
    end

    def initialize(image)
      @image = image
    end

    def draw!(image, x ,y)
      self.image.replace!(image.image, x, y)
    end

    def save_temp
      tmp = Tempfile.new
      image.save(tmp.path)
      tmp
    end

    def to_blob
      image.to_datastream.to_blob
    end

    def save(path)
      image.save(path)
    end

    def width
      image.width
    end

    def height
      image.height
    end

    protected

    attr_reader :image
  end
end
