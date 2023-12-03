module PixelData
  extend ActiveSupport::Concern

  included do
    belongs_to :painting

    validates :row, :col, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates :color, presence: true, length: { is: 3 }
  end
end
