module PandaDoc
  module Objects
    class Error
      include Virtus.model

      attribute :type,    String
      attribute :detail,  String
    end
  end
end
