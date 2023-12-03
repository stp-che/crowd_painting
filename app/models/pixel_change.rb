class PixelChange < ApplicationRecord
  include PixelData

  belongs_to :user
end
