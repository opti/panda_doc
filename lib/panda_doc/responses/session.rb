module PandaDoc
  module Responses
    class Session < Representable::Decorator
      include Representable::Hash

      property :id
      property :expires_at
    end
  end
end
