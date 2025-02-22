# frozen_string_literal: true

require "forwardable"
require "json"

require "faraday"
require "faraday/multipart"
require "dry-struct"
require "dry-configurable"

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module PandaDoc
  class << self
    def configure(&block)
      Configuration.configure(&block)
    end

    def configuration
      Configuration.config
    end
  end
end

loader.eager_load
