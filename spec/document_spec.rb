require "helper"

RSpec.shared_examples "a document object interface" do
  %w(
    uuid
    name
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

  %w(
    email
    first_name
    last_name
    recipient_type
    has_completed
  ).each do |method|
    it "has recipients.#{method}" do
      expect(
        subject.recipients.first.public_send(method)
      ).to eq(body["recipients"].first[method])
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
      "uuid" => "DOCUMENT_UUID",
      "status" => "document.uploaded",
      "name" => "DOCUMENT_NAME",
      "recipients" => [
        {
          "email" => "john.appleseed@yourdomain.com",
          "first_name" => "John",
          "last_name" => "Appleseed",
          "recipient_type" => "signer",
          "has_completed" => false
        }
      ],
      "date_created" => "2014-10-06T08:42:13.836022Z",
      "date_modified" => "2014-10-06T08:42:13.836048Z"
    }
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
end
