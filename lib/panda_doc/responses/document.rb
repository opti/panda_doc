module PandaDoc
  module Responses
    class Document < Representable::Decorator
      include Representable::Hash

      property :uuid
      property :status
      property :name
      property :created_at, as: :date_created
      property :updated_at, as: :date_modified

      collection :recipients, class: PandaDoc::Objects::Recipient do
        property :email
        property :first_name
        property :last_name
        property :recipient_type
        property :has_completed
      end
    end
  end
end
