# frozen_string_literal: true

module PandaDoc
  module Objects
    class Recipient < Base
      attribute :email, Types::Coercible::String
      attribute :first_name, Types::Coercible::String.optional
      attribute :last_name, Types::Coercible::String.optional
      attribute :recipient_type, Types::Coercible::String
      attribute :has_completed, Types::Params::Bool
    end
  end
end
