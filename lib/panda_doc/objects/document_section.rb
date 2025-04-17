module PandaDoc
  module Objects
    class DocumentSection < Base
      attribute :uuid, Types::String
      attribute :document_uuid, Types::String
      attribute :status, Types::Custom::DocumentStatus
      attribute :name, Types::String

      attribute :date_created, Types::Params::DateTime
      attribute :date_modified, Types::Params::DateTime

      alias_method :created_at, :date_created
      alias_method :updated_at, :date_modified
    end
  end
end
