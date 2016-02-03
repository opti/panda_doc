module PandaDoc
  module Objects
    class Error
      include Virtus.model

      attribute :type,    String
      attribute :message, String
      attribute :code,    String
    end
  end
end
