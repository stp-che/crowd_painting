class Pixel < ApplicationRecord
  include PixelData

  scope :after, ->(datetime) { where arel_table[:updated_at].gt(datetime) }
end
