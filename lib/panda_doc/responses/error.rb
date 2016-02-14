module PandaDoc
  module Responses
    class Error < Representable::Decorator
      include Representable::Hash

      property :type

      property :message, as: :detail,
        skip_parse: ->(doc:, **) { doc["detail"].is_a?(Hash) }

      nested :detail, skip_parse: ->(doc:, **) {
        doc["detail"].is_a?(String)
      } do
        property :message
        property :code
      end
    end
  end
end
