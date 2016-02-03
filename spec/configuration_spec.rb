RSpec.describe PandaDoc::Configuration do
  after { reset_config }

  subject { PandaDoc.configuration }

  context "access token" do
    before do
      PandaDoc.configure do |config|
        config.access_token = "foo"
      end
    end

    it { expect(subject.access_token).to eq("foo") }
  end

  context "endpoint" do
    it { expect(subject.endpoint).to eq("https://api.pandadoc.com") }
  end

  private

  def reset_config
    PandaDoc.configuration = nil
    PandaDoc.configure {}
  end
end
