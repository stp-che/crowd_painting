module PixelData
  extend ActiveSupport::Concern

  included do
    serialize :color, coder: Color

    belongs_to :painting

    validates :row, :col, presence: true, comparison: { greater_than_or_equal_to: 0 }
    validates :color, presence: true

    validates_each :color do |record, attr, value|
      record.errors.add(:color) unless value.kind_of?(Color)
    end

    def color=(clr)
      clr = Color.new(clr) unless clr.kind_of?(Color)
      super clr
    end
  end

  class Color
    BYTESIZE = 3
    REGEXP = /\A[0-9a-f]{6}\Z/i

    class << self
      def load(binary_str)
        return nil if binary_str.nil?

        new binary_str
      end

      def dump(color)
        color.binary_str
      end

      def parse_json(str)
        return nil if str.nil?

        raise InvalidString.new(str) unless str =~ REGEXP

        new str.scan(/../).map { |x| x.hex }.pack('c*')
      end
    end

    attr_reader :binary_str

    def initialize(binary_str)
      raise InvalidBinary.new(binary_str) if binary_str.nil? || binary_str.bytesize != BYTESIZE

      @binary_str = binary_str
    end

    def as_json
      @binary_str.unpack1('H*')
    end

    class InvalidBinary < StandardError
      def initialize(binary_str)
        @binary_str = binary_str
      end

      def message
        "invalid color binary #{@binary_str.inspect}"
      end
    end

    class InvalidString < StandardError
      def initialize(str)
        @str = str
      end

      def message
        "invalid color string #{@str.inspect}"
      end
    end
  end
end
