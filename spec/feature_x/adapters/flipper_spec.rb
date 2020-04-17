klass = FeatureX::Adapters::Flipper

RSpec.describe klass do

  describe ".setup" do
    it "doesnt raise an error" do
      klass.setup
    end
  end

  describe ".enabled?" do
    before(:each) { klass.setup }
    context "looking up a flag that doesnt exist" do
      it "returns nil" do
        expect(klass.enabled?("some_flag")).to be_nil
      end
    end
  end

end