# frozen_string_literal: true

module PandaDoc
  module Objects
    class EditingSession < Base
      attribute :id, Types::Coercible::String
      attribute :expires_at, Types::Params::DateTime
      attribute :key, Types::Coercible::String
      attribute :document_id, Types::Coercible::String
    end
  end
end
