# frozen_string_literal: true

module PandaDoc
  module Objects
    class Token < Base
      attribute :name, Types::Coercible::String.optional
      attribute? :value, Types::Coercible::String.optional
    end
  end
end
