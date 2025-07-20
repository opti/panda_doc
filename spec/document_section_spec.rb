# frozen_string_literal: true

require "helper"

RSpec.shared_examples "a document section object interface" do
  %w(
    uuid
    document_uuid
    name
  ).each do |method|
    it "has #{method}" do
      expect(subject.public_send(method)).to eq(body[method])
    end
  end

  it "has coerced status" do
    expect(subject.status).to eq("UPLOADED")
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
end

RSpec.shared_examples "a document section failure result" do
  it { expect { subject }.to raise_error(PandaDoc::FailureResult) }
end


RSpec.describe PandaDoc::DocumentSection do
  let(:failed_response) { double(success?: false, body: Hash.new) }
  let(:successful_response) { double(success?: true, body: body) }
  let(:document_uuid) { "DOCUMENT_UUID" }
  let(:document_body) do
    {
      "uuid" => "SECTION_UUID",
      "document_uuid" => "DOCUMENT_UUID",
      "status" => "document_sections_upload.UPLOADED",
      "name" => "null",
      "date_created" => "2023-08-28T15:48:09.379860Z",
      "date_modified" => "2023-08-28T15:48:09.379860Z",
      "info_message" => "You need to poll the Document Sections Upload Status method until the status will be changed to document_sections_upload.PROCESSED"
    }
  end

  describe ".list" do
    subject { described_class.list(document_uuid) }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:get, "/documents/#{document_uuid}/sections")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a document section failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { { "results" => [document_body] } }

      it "returns an array of document sections" do
        expect(subject.results).to all(be_a(PandaDoc::Objects::DocumentSection))
      end

      it "contains document sections" do
        expect(subject.document_sections.first).to be_a(PandaDoc::Objects::DocumentSection)
      end
    end
  end

  describe ".create" do
    subject { described_class.create(document_uuid, name: "Foo") }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:post, "/documents/#{document_uuid}/sections/uploads", name: "Foo")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a document section failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { document_body }

      it_behaves_like "a document section object interface"
    end
  end

  describe ".delete" do
    let(:section_uuid) { "SECTION_UUID" }
    subject { described_class.delete(document_uuid, section_uuid) }

    before do
      allow(PandaDoc::ApiClient).to receive(:request)
        .with(:delete, "/documents/#{document_uuid}/sections/#{section_uuid}")
        .and_return(response)
    end

    context "with failed response" do
      let(:response) { failed_response }

      it_behaves_like "a document section failure result"
    end

    context "with successful response" do
      let(:response) { successful_response }
      let(:body) { {} }

      it "returns a success result" do
        expect(subject).to be_a(PandaDoc::SuccessResult)
      end
    end
  end
end
