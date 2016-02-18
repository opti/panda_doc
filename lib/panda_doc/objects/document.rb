module PandaDoc
  module Objects
    class Document
      include Virtus.model

      attribute :uuid,       String
      attribute :status,     Objects::Status
      attribute :name,       String
      attribute :recipients, Array[Objects::Recipient]
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
    end
  end
end
