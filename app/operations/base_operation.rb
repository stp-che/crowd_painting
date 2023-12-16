require 'dry/monads/do'
require 'dry/monads/result'

class BaseOperation
  include Dry::Monads::Do
  include Dry::Monads::Result::Mixin
end
