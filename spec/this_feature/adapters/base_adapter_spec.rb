
RSpec.shared_examples "examples for interface method" do |fn_name, *args|
  it "raises an unimplemented error for `#{fn_name}` with args #{args}`" do
    expect do
      described_class.public_send(fn_name, *args)
    end.to raise_error(ThisFeature::UnimplementedError) do |err|
      expect(err.message).to eq("class #{described_class.name} doesnt implement method .#{fn_name}")
    end
  end
end

RSpec.describe ThisFeature::Adapters::Base do
  context "methods providing an interface for descendent classes to implement" do
    include_examples "examples for interface method", :setup
    include_examples "examples for interface method", :present?, :some_flag_name
    include_examples "examples for interface method", :on?, :some_flag_name
    include_examples "examples for interface method", :on?, :some_flag_name, context: :fake_user, data: :stuff
    include_examples "examples for interface method", :off?, :some_flag_name
    include_examples "examples for interface method", :off?, :some_flag_name, context: :fake_user, data: :stuff
    include_examples "examples for interface method", :on!, :some_flag_name
    include_examples "examples for interface method", :on!, :some_flag_name, context: :fake_user, data: :stuff
    include_examples "examples for interface method", :off!, :some_flag_name
    include_examples "examples for interface method", :off!, :some_flag_name, context: :fake_user, data: :stuff

    it 'implements #control? and returns false by default' do
      expect(described_class.control?(:some_flag_name)).to eq(false)
    end
  end
end
