klass = FeatureX::Adapters::FlipperAdapter

RSpec.describe klass do

  describe ".setup" do
    it "doesnt raise an error" do
      klass.setup
    end
  end

  describe ".enabled?" do
    let(:sample_flag) { "some flag" }
    before(:each) { klass.setup }

    context "when given just a flag name" do

      context "looking up a flag that doesnt exist" do
        it "returns nil" do
          skip
          expect(FlipperFeature.count).to eq 0
          expect(klass.enabled?(sample_flag)).to be_nil
        end
      end

      context "looking up a flag that is set to true" do
        it "returns true" do
          Flipper[sample_flag].enable
          expect(FlipperFeature.count).to eq 1
          expect(klass.enabled?(sample_flag)).to be true
        end
      end

      context "looking up a flag that is set to false" do
        it "returns false" do
          Flipper[sample_flag].disable
          expect(FlipperFeature.count).to eq 1
          expect(klass.enabled?(sample_flag)).to be false
        end
      end

    end

    context "when given a flag name and a user" do
      it "qualifies the search" do
        skip
      end
    end
  end

end