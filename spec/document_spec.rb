# frozen_string_literal: true

require "helper"

RSpec.shared_examples "a document object interface" do
  %w(
    id
    uuid
    name
    version
  ).each do |method|
    it "has #{method}" do
      expect(subject.public_send(method)).to eq(body[method])
    end
  end

  it "has coerced status" do
    expect(subject.status).to eq("uploaded")
  end

  it "has created_at" do
    expect(
      to_seconds(subject.created_at)
    ).to eq(to_seconds(body["date_created"]))
  end

  it "has updated_at" do
    expect(
      to_seconds(subject.updated_at)
    ).to eq(to_seconds(body["date_modified"]))
  end

  it "has expires_at" do
    expect(
      to_seconds(subject.expires_at)
    ).to eq(to_seconds(body["expiration_date"]))
  end

  %w(
    email
    first_name
    last_name
    recipient_type
    has_completed
    roles
    shared_link
    contact_id
  ).each do |method|
    it "has recipients.#{method}" do
      expect(
        subject.recipients.first.public_send(method)
      ).to eq(body["recipients"].first[method])
    end
  end

  %w(
    name
    value
  ).each do |method|
    it "has tokens.#{method}" do
      expect(
        subject.tokens.first.public_send(method)
      ).to eq(body["tokens"].first[method])
    end
  end

  %w(
    uuid
    name
    title
    placeholder
    value
  ).each do |method|
    it "has fields.#{method}" do
      expect(
        subject.fields.first.public_send(method)
      ).to eq(body["fields"].first[method])
    end
  end
end

RSpec.shared_examples "a failure result" do
  it { expect { subject }.to raise_error(PandaDoc::FailureResult) }
end

RSpec.describe PandaDoc::Document do
  let(:failed_response) { double(success?: false, body: Hash.new) }
  let(:successful_response) { double(success?: true, body: body) }
  let(:document_body) do
    {
      "id" => "DOCUMENT_UUID",
      "uuid" => "DOCUMENT_UUID",
      "status" => "document.uploaded",
      "name" => "DOCUMENT_NAME",
      "recipients" => [
        {
          "email" => "john.appleseed@yourdomain.com",
          "first_name" => "John",
          "last_name" => "Appleseed",
          "recipient_type" => "signer",
          "has_completed" => false,
          "roles" => ["MyRole1", "MyRole2"],
          "shared_link" => "https://app.pandadoc.com/document/uuid",
          "contact_id" => "7kqXgjFejB2toXxjcC5jfZ"
        },
        {}
      ],
      "date_created" => "2014-10-06T08:42:13.836022Z",
      "date_modified" => "2014-10-06T08:42:13.836048Z",
      "expiration_date" => "2021-02-22T00:51:59.474648Z",
      "version" => "1",
      "tokens" => [
        { "name" => "token.name", "value" => "token value" }
      ],
      "fields" => [
        {
          "uuid" => "0e05e47d-bcbd-49a2-a649-9d00a310857c",
          "name" => "Signature",
          "title" => "",
          "placeholder" => "Signature",
          "value" => {},
          "assigned_to" =>
            {
              "id" => "FBs7ahvjDwgPEumTSLfJs8",
              "first_name" => nil,
              "last_name" => nil,
              "email" => "john.appleseed@yourdomain.com",
              "recipient_type" => "signer",
              "has_completed" => true,
              "role" => "",
              "type" => "recipient"
            }
        }
      ]
    }
  end

  describe ".list" do
    subject(:list) { described_class.list }

    before do
      allow(PandaDoc::ApiClient).to receive(:request).with(:get, "/documents").and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { { "results": [document_body] } }

      it "returns an array of documents" do
        expect(list.results).to all(be_a(PandaDoc::Objects::Document))
      end

      it "returns results as an array of documents" do
        expect(list.results).to all(be_a(PandaDoc::Objects::Document))
      end

      it "behaves like an array of document object interfaces" do
        expect(list.results.first).to respond_to(*PandaDoc::Objects::Document.attribute_names)
      end
    end
  end

  describe ".create" do
    subject { described_class.create(name: "Foo") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:post, "/documents", name: "Foo")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { document_body }

      it_behaves_like "a document object interface"
    end
  end

  describe ".send" do
    subject { described_class.send("uuid", message: "foo") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:post, "/documents/uuid/send", message: "foo")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { document_body }

      it_behaves_like "a document object interface"
    end
  end

  describe ".session" do
    subject { described_class.session("uuid", recipient: "foo", lifetime: 30) }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:post, "/documents/uuid/session", recipient: "foo", lifetime: 30)
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) do
        {"id" => "SESSION_UUID", "expires_at" => "2014-06-15T01:30:00Z"}
      end

      it { expect(subject.id).to eq(body["id"]) }

      it "has expires_at" do
        expect(
          to_seconds(subject.expires_at)
        ).to eq(to_seconds(body["expires_at"]))
      end
    end
  end

  describe ".editing_session" do
    subject { described_class.editing_session("uuid", recipient: "foo", lifetime: 30) }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:post, "/documents/uuid/editing-sessions", recipient: "foo", lifetime: 30)
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) do
        {
          "id" => "SESSION_UUID",
          "expires_at" => "2014-06-15T01:30:00Z",
          "key" => "985b695b56eaaa571e9bb8e522afd5bd335c32d7",
          "document_id" => "pSgK5XYZjyg3zXYZxsoUWg"
        }
      end

      it { expect(subject.id).to eq(body["id"]) }
      it { expect(subject.key).to eq(body["key"]) }
      it { expect(subject.document_id).to eq(body["document_id"]) }

      it "has expires_at" do
        expect(
          to_seconds(subject.expires_at)
        ).to eq(to_seconds(body["expires_at"]))
      end
    end
  end

  describe ".download" do
    subject { described_class.download("uuid") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:get, "/documents/uuid/download")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { double(success?: true, body: "") }

      it { expect(subject.body).to eq(response.body) }
    end
  end

  describe ".find" do
    subject { described_class.find("uuid") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:get, "/documents/uuid")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { document_body }

      it_behaves_like "a document object interface"
    end
  end

  describe ".details" do
    subject { described_class.details("uuid") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:get, "/documents/uuid/details")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { document_body }

      it_behaves_like "a document object interface"
    end

    context "with empty token value" do
      let(:response) { successful_response }
      let(:body) { document_body.merge("tokens" => [{"name" => ""}]) }

      it_behaves_like "a document object interface"
    end
  end

  describe ".move_to_draft" do
    subject { described_class.move_to_draft("uuid") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:post, "/documents/uuid/draft")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { document_body }

      it_behaves_like "a document object interface"
    end
  end

  describe ".update" do
    subject { described_class.update("uuid", metadata: { hello: "world" })}

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:patch, "/documents/uuid", metadata: { hello: "world" })
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { "" }

      it { expect { subject }.not_to raise_error }
    end
  end
end
