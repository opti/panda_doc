module PandaDoc
  module Responses
    class Error < Representable::Decorator
      include Representable::Hash

      property :type

      nested :detail do
        property :message
        property :code
      end
    end
  end
end
