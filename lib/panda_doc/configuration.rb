# frozen_string_literal: true

module PandaDoc
  class Configuration
    extend Dry::Configurable

    setting :access_token
    setting :api_key
    setting :logger

    setting :endpoint, "https://api.pandadoc.com"
  end
end
