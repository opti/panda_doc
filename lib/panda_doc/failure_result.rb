module PandaDoc
  class FailureResult
    extend Forwardable
    def_delegators :response, :status, :success?

    attr_reader :error

    attr_reader :response
    private :response

    def initialize(response)
      @response = response
      @error = Responses::Error.new(Objects::Error.new).from_hash(response.body)
    end
  end
end
