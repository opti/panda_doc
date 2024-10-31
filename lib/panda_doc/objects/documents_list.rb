# frozen_string_literal: true

module PandaDoc
  module Objects
    # Represents a list of documents
    class DocumentsList < Base
      attribute :results, Types::Array.of(Objects::Document).default([].freeze)

      alias_method :documents, :results
    end
  end
end
