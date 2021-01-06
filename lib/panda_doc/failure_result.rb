# frozen_string_literal: true

module PandaDoc
  class FailureResult < StandardError
    extend Forwardable
    def_delegators :response, :status, :success?
    def_delegators :error, :type, :detail

    attr_reader :error

    attr_reader :response
    private :response

    def initialize(response)
      @response = response
      @error = Objects::Error.new(response.body)
    end

    def to_s
      "#{status} #{type}: #{detail}"
    end
  end
end
