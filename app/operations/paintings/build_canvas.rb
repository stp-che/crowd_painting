module Paintings
  class BuildCanvas < ::BaseOperation
    DEFAULT_COLOR = ChunkyPNG::Color.parse('#ffffff')

    def call(painting)
      png = ChunkyPNG::Image.new(painting.width, painting.height, DEFAULT_COLOR).tap do |png|
        painting.pixels.each do |px|
          png[px.col, px.row] = ChunkyPNG::Color.parse(px.color.hex_str)
        end
      end

      Success(png.to_blob(:fast_rgb))
    end
  end
end
