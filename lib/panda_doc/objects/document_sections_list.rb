# frozen_string_literal: true

module PandaDoc
  module Objects
    # Represents a list of document sections
    class DocumentSectionsList < Base
      attribute :results, Types::Array.of(Objects::DocumentSection).default([].freeze)

      alias_method :document_sections, :results
    end
  end
end