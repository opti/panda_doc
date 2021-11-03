# frozen_string_literal: true

RSpec.describe PandaDoc::ApiClient do
  subject(:client) { described_class.new }

  before do
    PandaDoc.configure do |config|
      config.access_token  = "foo"
    end
  end

  describe "connection" do
    subject(:connection) do
      client.connection.tap do |conn|
        conn.adapter :test do |stub|
          stub.get("/auth-echo") do |env|
            [200, {}, env[:request_headers]["Authorization"]]
          end
        end
      end
    end

    let(:response) { connection.get("/auth-echo") }

    it { is_expected.to be_an_instance_of(Faraday::Connection) }

    it "sets json handlers" do
      expect(
        subject.builder.handlers
      ).to include(FaradayMiddleware::EncodeJson, FaradayMiddleware::ParseJson)
    end

    it "sets bearer auth header" do
      expect(response.body).to eq("Bearer foo")
    end
  end

  describe ".request" do
    [:post, :get].each do |verb|
      it "forwards #{verb} request to an instance" do
        expect_any_instance_of(
          described_class
        ).to receive(verb).with("foo", bar: :baz)

        described_class.request(verb, "foo", bar: :baz)
      end
    end

    context "with file attached" do
      let(:client) { double }

      before do
        allow(described_class).to receive(:new) { client }
        allow(client).to receive(:post)
      end

      it "instantiates with 'multipart: true'" do
        described_class.request(:post, "foo", file: :f, bar: :baz)

        expect(described_class).to have_received(:new).with(multipart: true)
        expect(client).to have_received(:post)
          .with("foo", file: :f, data: JSON.generate(bar: :baz))
      end
    end
  end

  describe "#post" do
    context "as json" do
      before(:each) do
        @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post("/public/v1/foo") { [200, {}, ""] }
          stub.post("/public/v1/bar", '{"key":"value"}') { [200, {}, ""] }
        end
      end

      before do
        subject.connection.builder.handlers.pop
        subject.connection.adapter(:test, @stubs)
      end

      it "makes request to full url" do
        response = subject.post("foo", {})
        expect(
          response.env.url.to_s
        ).to eq("https://api.pandadoc.com/public/v1/foo")
      end

      it "normalizes url before making a request" do
        expect(subject.post("foo")).to be_success
        expect(subject.post("/foo")).to be_success
      end

      it "makes request with json data" do
        expect(subject.post("/bar", { key: "value" })).to be_success
      end
    end

    context "as multipart form" do
      subject { described_class.new(multipart: true) }

      let(:file) do
        Faraday::UploadIO.new(__FILE__, "application/pdf")
      end

      let(:response) do
        subject.post("/bar", file: file, data: '{"key":"value"}')
      end

      before(:each) do
        @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post("/public/v1/bar") do |env|
            posted_as = env[:request_headers]["Content-Type"]
            [200, {"Content-Type" => posted_as}, env[:body]]
          end
        end
      end

      before do
        subject.connection.builder.handlers.pop
        subject.connection.adapter(:test, @stubs)
      end

      it { expect(response).to be_success }
      it { expect(response.body).to be_a(Faraday::CompositeReadIO) }
      it { expect(response.headers["Content-Type"]).to include("multipart/form-data") }
    end
  end

  describe "#get" do
    before(:each) do
      @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/public/v1/foo") { [200, {}, ""] }
        stub.get("/public/v1/bar?key=value") { [200, {}, ""] }
      end
    end

    before do
      subject.connection.builder.handlers.pop
      subject.connection.adapter(:test, @stubs)
    end

    it "makes request to full url" do
      response = subject.get("foo", {})
      expect(
        response.env.url.to_s
      ).to eq("https://api.pandadoc.com/public/v1/foo")
    end

    it "normalizes url before making a request" do
      expect(subject.get("foo")).to be_success
      expect(subject.get("/foo")).to be_success
    end

    it "makes request with params" do
      expect(subject.get("/bar", { key: "value" })).to be_success
    end
  end

  describe "logger" do
    let(:io) { StringIO.new }

    before do
      PandaDoc.configure do |config|
        config.logger = Logger.new(io)
      end

      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/public/v1/foo") { [200, {foo: "bar"}, "test"] }
      end

      subject.connection.builder.handlers.pop
      subject.connection.adapter(:test, stubs)
    end

    after do
      PandaDoc.configure do |config|
        config.logger = nil
      end
    end

    before { subject.post("/foo", bar: :baz) }

    it "logs request method and url" do
      expect(io.string).to include("POST https://api.pandadoc.com/public/v1/foo")
    end

    it "logs request headers" do
      expect(io.string).to include("Authorization")
      expect(io.string).to include("User-Agent")
      expect(io.string).to include("Content-Type")
    end

    it "logs request body" do
      expect(io.string).to include('request: {"bar":"baz"}')
    end

    it "logs response status" do
      expect(io.string).to include("Status 200")
    end

    it "logs response headers" do
      expect(io.string).to include('response: Foo: "bar"')
    end

    it "logs response body" do
      expect(io.string).to include("response: test")
    end
  end
end
