# frozen_string_literal: true

module PandaDoc
  class SuccessResult
    attr_reader :object
    private :object

    def initialize(object)
      @object = object
    end

    def success?
      true
    end

    def method_missing(method_name, *arguments, &block)
      if object.respond_to?(method_name)
        object.send(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      object.respond_to?(method_name) || super
    end
  end
end
