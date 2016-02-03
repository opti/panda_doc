module PandaDoc
  class ResponseFactory
    attr_reader :type
    private :type

    def initialize(type)
      @type = type.capitalize
    end

    def build
      response_class.new(object_class.new)
    end

    private

    def response_class
      class_for("Responses")
    end

    def object_class
      class_for("Objects")
    end

    def class_for(namespace)
      Object.const_get("PandaDoc::#{namespace}::#{type}")
    end
  end
end
