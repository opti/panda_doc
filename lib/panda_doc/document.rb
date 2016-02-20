module PandaDoc
  module Document
    extend self

    def create(data)
      respond(ApiClient.request(:post, "/documents", data))
    end

    def send(uuid, **data)
      respond(ApiClient.request(:post, "/documents/#{uuid}/send", data))
    end

    def session(uuid, **data)
      respond(
        ApiClient.request(:post, "/documents/#{uuid}/session", data),
        type: :session
      )
    end

    private

    def respond(response, type: :document)
      fail FailureResult.new(response) unless response.success?

      SuccessResult.new(
        ResponseFactory.new(type).build.from_hash(response.body)
      )
    end
  end
end
