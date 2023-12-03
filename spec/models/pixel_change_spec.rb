require 'rails_helper'
require_relative 'shared_examples/with_pixel_data'

RSpec.describe PixelChange do
  include_examples 'with pixel data', :pixel_change
end
