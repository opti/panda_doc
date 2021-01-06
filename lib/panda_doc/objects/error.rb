# frozen_string_literal: true

module PandaDoc
  module Objects
    class Error < Base
      attribute? :type, Types::Coercible::String.optional
      attribute? :detail, Types::Params::Hash.optional | Types::Coercible::String.optional
    end
  end
end
