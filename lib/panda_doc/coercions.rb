# frozen_string_literal: true

module PandaDoc
  module Coercions
    def self.to_splitted_string(value)
      value.to_s.split(".").last
    end
  end
end
