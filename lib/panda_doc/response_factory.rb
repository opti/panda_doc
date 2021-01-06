# frozen_string_literal: true

module PandaDoc
  class ResponseFactory
    attr_reader :type
    private :type

    def self.build(type)
      new(type).build
    end

    def initialize(type)
      @type = type.capitalize
    end

    def build
      PandaDoc::Objects.const_get(type)
    end
  end
end
