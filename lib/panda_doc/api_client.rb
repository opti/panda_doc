module PandaDoc
  class ApiClient

    class << self
      def request(verb, path, **data)
        new.public_send(verb, path, data)
      end
    end

    attr_reader :connection

    attr_reader :url_prefix
    private :url_prefix

    def initialize
      @url_prefix = "/public/v1"
      @connection = Faraday.new(PandaDoc.configuration.endpoint) do |conn|
        conn.authorization :Bearer, PandaDoc.configuration.access_token
        conn.request       :json
        if PandaDoc.configuration.logger
          conn.response    :logger, PandaDoc.configuration.logger, bodies: true
        end
        conn.response      :json, content_type: /\bjson$/
        conn.adapter       Faraday.default_adapter
      end
    end

    def post(path, **data)
      connection.post(normalized_path(path), data)
    end

    def get(path, **data)
      connection.get(normalized_path(path), data)
    end

    private

    def normalized_path(path)
      url_prefix + normalize_path(path)
    end

    def normalize_path(path)
      Faraday::Utils.normalize_path(path)
    end
  end
end
