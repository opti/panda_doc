# frozen_string_literal: true

module PandaDoc
  module Objects
    class Document < Base
      attribute :uuid, Types::String
      attribute :status, Types::Custom::DocumentStatus
      attribute :name, Types::String
      attribute? :recipients, Types::Array.of(Objects::Recipient)
      attribute :date_created, Types::Params::DateTime
      attribute :date_modified, Types::Params::DateTime

      alias_method :created_at, :date_created
      alias_method :updated_at, :date_modified
    end
  end
end
