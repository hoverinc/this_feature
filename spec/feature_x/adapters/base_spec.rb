RSpec.shared_examples "examples for interface method" do |fn_name, *params|
  it "raises an error" do
    expect do
      FeatureX::Adapters::Base.public_send(fn_name)
    end.to raise_error(FeatureX::Error) do |err|
      expect(err.message).to eq("not implemented")
    end
  end
end

RSpec.describe FeatureX::Adapters::Base do
  context "methods providing an interface for descendent classes to implement" do
    describe ".setup" do
      include_examples "examples for interface method", :setup
    end
  end
end