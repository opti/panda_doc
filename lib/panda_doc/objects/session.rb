# frozen_string_literal: true

module PandaDoc
  module Objects
    class Session < Base
      attribute :id, Types::Coercible::String
      attribute :expires_at, Types::Params::DateTime
    end
  end
end
