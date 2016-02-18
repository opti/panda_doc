module PandaDoc
  module Objects
    class Status < Virtus::Attribute
      def coerce(value)
        value.to_s.split(".").last
      end
    end
  end
end
