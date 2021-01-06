# frozen_string_literal: true

module PandaDoc
  module Types
    include Dry.Types()

    module Custom
      DocumentStatus = Dry::Types["nominal.string"].constructor(
        Coercions.method(:to_splitted_string)
      )
    end
  end
end
