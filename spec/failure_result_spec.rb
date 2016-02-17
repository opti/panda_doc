RSpec.describe PandaDoc::FailureResult do
  let(:body) do
    {
      "type" => "permissions_error",
      "detail"=> {
        "message" => "The Subscription is not active",
        "code" => "subscription-inactive"
      }
    }
  end

  let(:response) do
    double(:response, status: 400, success?: false, body: body)
  end

  subject { described_class.new(response) }

  context "response" do
    it "should have status" do
      expect(subject.status).to eq(response.status)
    end

    it "should not be successful" do
      expect(subject).not_to be_success
    end
  end

  context "error object" do
    it { expect(subject.error.type).to eq(body["type"]) }

    it { expect(subject.error.detail).to be_a(Hash) }
    it { expect(subject.error.detail).to eq(body["detail"]) }

    context "with simple details" do
      let(:body) do
        {"type" => "request_error", "detail" => "Not found"}
      end

      it { expect(subject.error.detail).to be_a(String) }
      it { expect(subject.error.detail).to eq(body["detail"])  }
    end

  end
end
