# frozen_string_literal: true

module PandaDoc
  module Objects
    class Field < Base
      attribute :uuid, Types::Coercible::String
      attribute :name, Types::Coercible::String.optional
      attribute :title, Types::Coercible::String.optional
      attribute? :placeholder, Types::Coercible::String.optional
      attribute :value, Types::Nil | Types::Hash | Types::Coercible::String
      attribute? :assigned_to, PandaDoc::Objects::Recipient
    end
  end
end
