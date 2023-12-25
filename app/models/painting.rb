class Painting < ApplicationRecord
  SIZES = {
    '50 x 50' => [50, 50],
    '100 x 100' => [100, 100],
    '200 x 200' => [200, 200]
  }.freeze

  belongs_to :user
  has_many :pixels
end
