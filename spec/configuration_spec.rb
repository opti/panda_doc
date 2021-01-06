# frozen_string_literal: true

RSpec.describe PandaDoc::Configuration do
  before { described_class.reset_config }
  after { described_class.reset_config }

  subject(:configuration) { PandaDoc.configuration }

  describe "#access_token" do
    before do
      PandaDoc.configure do |config|
        config.access_token = "foo"
      end
    end

    subject(:access_token) { configuration.access_token }

    it { is_expected.to eq("foo") }
  end

  describe "#api_key" do
    before do
      PandaDoc.configure do |config|
        config.api_key = "bar"
      end
    end

    subject(:api_key) { configuration.api_key }

    it { is_expected.to eq("bar") }
  end

  describe "#logger" do
    before do
      PandaDoc.configure do |config|
        config.logger = Logger.new(StringIO.new)
      end
    end

    subject(:logger) { configuration.logger }

    it { is_expected.to be_an_instance_of(Logger) }
  end

  describe "#endpoint" do
    subject(:endpoint) { configuration.endpoint }

    context "with default value" do
      it { is_expected.to eq("https://api.pandadoc.com") }
    end

    context "with overriden value" do
      before do
        PandaDoc.configure do |config|
          config.endpoint = "https://api-dev.pandadoc.com"
        end
      end

      it { is_expected.to eq("https://api-dev.pandadoc.com") }
    end
  end
end
