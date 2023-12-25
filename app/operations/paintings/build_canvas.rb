module Paintings
  class BuildCanvas
    DEFAULT_COLOR = ChunkyPNG::Color.parse('#ffffff')

    def call(painting)
      ChunkyPNG::Image.new(painting.width, painting.height, DEFAULT_COLOR).tap do |png|
        painting.pixels.each do |px|
          png[px.col, px.row] = ChunkyPNG::Color.parse(px.color.hex_str)
        end
      end.to_blob(:fast_rgb)
    end
  end
end
