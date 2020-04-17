klass = FeatureX::Adapters::BaseAdapter

RSpec.shared_examples "examples for interface method" do |fn_name, *args|
  it "raises an unimplemented error for `#{fn_name}`" do
    expect do
      klass.public_send(fn_name, *args)
    end.to raise_error(FeatureX::UnimplementedError) do |err|
      expect(err.message).to eq("class #{klass.name} doesnt implement method .#{fn_name}")
    end
  end
end

RSpec.describe klass do
  context "methods providing an interface for descendent classes to implement" do
    include_examples "examples for interface method", :setup
    include_examples "examples for interface method", :enabled?, :some_flag_name
  end
end