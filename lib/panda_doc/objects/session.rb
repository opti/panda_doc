module PandaDoc
  module Objects
    class Session
      include Virtus.model

      attribute :id,         String
      attribute :expires_at, DateTime
    end
  end
end
