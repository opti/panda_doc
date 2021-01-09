# frozen_string_literal: true

module PandaDoc
  module Objects
    class Document < Base
      attribute :id, Types::String
      attribute? :uuid, Types::String
      attribute :status, Types::Custom::DocumentStatus
      attribute :name, Types::String
      attribute? :recipients, Types::Array.of(Objects::Recipient)
      attribute :date_created, Types::Params::DateTime
      attribute :date_modified, Types::Params::DateTime
      attribute? :expiration_date, Types::Params::DateTime.optional
      attribute :version, Types::String.optional

      attribute? :tokens, Types::Array.of(Objects::Token)
      attribute? :fields, Types::Array.of(Objects::Field)

      alias_method :created_at, :date_created
      alias_method :updated_at, :date_modified
      alias_method :expires_at, :expiration_date
    end
  end
end
