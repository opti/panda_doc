RSpec.describe PandaDoc::ApiClient do
  before do
    PandaDoc.configure do |config|
      config.access_token  = "foo"
    end
  end

  describe "connection" do
    it { expect(subject.connection).to be_an_instance_of(Faraday::Connection) }

    it "sets json handlers" do
      expect(
        subject.connection.builder.handlers
      ).to include(FaradayMiddleware::EncodeJson, FaradayMiddleware::ParseJson)
    end

    it "sets bearer auth header" do
      expect(subject.connection.headers["Authorization"]).to eq("Bearer foo")
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
  end

  describe "#post" do
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
end
