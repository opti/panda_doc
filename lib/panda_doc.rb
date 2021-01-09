# frozen_string_literal: true

require "forwardable"
require "json"

require "faraday"
require "faraday_middleware"
require "dry-struct"
require "dry-configurable"

require "panda_doc/api_client"
require "panda_doc/configuration"
require "panda_doc/coercions"
require "panda_doc/types"
require "panda_doc/failure_result"
require "panda_doc/success_result"
require "panda_doc/document"
require "panda_doc/response_factory"
require "panda_doc/objects/base"
require "panda_doc/objects/recipient"
require "panda_doc/objects/token"
require "panda_doc/objects/field"
require "panda_doc/objects/document"
require "panda_doc/objects/error"
require "panda_doc/objects/session"

require "panda_doc/version"

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
