RSpec.shared_examples 'examples for interface method' do |fn_name, args|
  it "raises an unimplemented error for `#{fn_name}` with args #{args}`" do
    expect do
      described_class.new.public_send(fn_name, args)
    end.to raise_error(ThisFeature::UnimplementedError) do |err|
      expect(err.message).to eq("class #{described_class.name} doesn't implement method .#{fn_name}")
    end
  end
end

RSpec.describe ThisFeature::Adapters::Base do
  context 'with methods providing an interface for descendent classes to implement' do
    include_examples 'examples for interface method', :present?, :some_flag_name
    include_examples 'examples for interface method', :on?, :some_flag_name

    include_examples 'examples for interface method',
                     :on?,
                     :some_flag_name,
                     context: :fake_user,
                     data: :stuff,
                     record: :fake_org

    include_examples 'examples for interface method', :off?, :some_flag_name

    include_examples 'examples for interface method',
                     :off?,
                     :some_flag_name,
                     context: :fake_user,
                     data: :stuff,
                     record: :fake_org

    it 'implements #control? and returns false by default' do
      expect(described_class.new.control?(:some_flag_name)).to be(false)
    end
  end
end
