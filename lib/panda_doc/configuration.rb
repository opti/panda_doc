module PandaDoc
  class Configuration
    attr_accessor :access_token

    def endpoint
      "https://api.pandadoc.com"
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configuration=(config)
      @configuration = config
    end

    def configure
      yield configuration
    end
  end
end
