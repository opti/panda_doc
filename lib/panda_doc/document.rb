# frozen_string_literal: true

module PandaDoc
  module Document
    extend self

    # @param options [Hash]
    def list(**options)
      respond(
        ApiClient.request(:get, "/documents", **options),
        type: :documents_list
      )
    end

    def create(data)
      respond(ApiClient.request(:post, "/documents", **data))
    end

    def update(uuid, **data)
      respond(
        ApiClient.request(:patch, "/documents/#{uuid}", **data),
        type: :empty
      )
    end

    def send(uuid, **data)
      respond(ApiClient.request(:post, "/documents/#{uuid}/send", **data))
    end

    def find(uuid)
      respond(ApiClient.request(:get, "/documents/#{uuid}"))
    end

    def details(uuid)
      respond(ApiClient.request(:get, "/documents/#{uuid}/details"))
    end

    def move_to_draft(uuid)
      respond(ApiClient.request(:post, "/documents/#{uuid}/draft"))
    end

    def session(uuid, **data)
      respond(
        ApiClient.request(:post, "/documents/#{uuid}/session", **data),
        type: :session
      )
    end

    def editing_session(uuid, **data)
      respond(
        ApiClient.request(:post, "/documents/#{uuid}/editing-sessions", **data),
        type: :editing_session
      )
    end

    def download(uuid)
      stream(ApiClient.request(:get, "/documents/#{uuid}/download"))
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
