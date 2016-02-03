module PandaDoc
  module Objects
    class Recipient
      include Virtus.model

      attribute :email,          String
      attribute :first_name,     String
      attribute :last_name,      String
      attribute :recipient_type, String
      attribute :has_completed,  Axiom::Types::Boolean
    end
  end
end
