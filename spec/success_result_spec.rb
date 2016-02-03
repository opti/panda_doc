RSpec.describe PandaDoc::SuccessResult do
  let(:object) { double(uuid: "foo", status: "sent", completed: false) }

  subject { described_class.new(object) }

  it "should be successful" do
    expect(subject).to be_success
  end

  it "should have uuid" do
    expect(subject.uuid).to eq(object.uuid)
  end

  it "should have status" do
    expect(subject.status).to eq(object.status)
  end

  it "should not be completed" do
    expect(subject.completed).to be_falsey
  end

  it "should raise no method error on missing method" do
    expect { subject.does_not_exist }.to raise_error(NoMethodError)
  end

  it "should not respond to missing method" do
    expect(subject).not_to respond_to(:does_not_exist)
  end
end
