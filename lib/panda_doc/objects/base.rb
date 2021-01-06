# frozen_string_literal: true

module PandaDoc
  module Objects
    class Base < Dry::Struct
      transform_keys(&:to_sym)
    end
  end
end
