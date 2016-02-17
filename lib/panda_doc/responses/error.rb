module PandaDoc
  module Responses
    class Error < Representable::Decorator
      include Representable::Hash

      property :type
      property :detail
    end
  end
end
