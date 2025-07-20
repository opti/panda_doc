# frozen_string_literal: true

module PandaDoc
  module DocumentSection
    extend self

    def list(document_uuid, **options)
      respond(
        ApiClient.request(:get, "/documents/#{document_uuid}/sections", **options),
        type: :document_sections_list
      )
    end

    def create(document_uuid, **data)
      respond(
        ApiClient.request(:post, "/documents/#{document_uuid}/sections/uploads", **data),
        type: :document_section
      )
    end

    def delete(document_uuid, section_uuid)
      respond(
        ApiClient.request(:delete, "/documents/#{document_uuid}/sections/#{section_uuid}"),
        type: :empty
      )
    end

    private

    def respond(response, type: :document)
      failure(response)

      SuccessResult.new(
        ResponseFactory.build(type).new(response.body)
      )
    end

    def stream(response)
      failure(response)

      SuccessResult.new(response)
    end

    def failure(response)
      raise FailureResult.new(response) unless response.success?
    end
  end
end
