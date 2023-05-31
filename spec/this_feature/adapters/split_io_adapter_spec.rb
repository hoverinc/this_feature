RSpec.describe ThisFeature::Adapters::SplitIo do
  let(:org_id) { 1 }
  let(:another_org_id) { 5 }

  let(:split_file_path) { File.expand_path(File.join('spec', 'support', 'files', 'splits.yaml')) }
  let(:split_client) { SplitIoClient::SplitFactoryBuilder.build('localhost', split_file: split_file_path).client }
  let(:adapter) { described_class.new(client: split_client) }

  context 'with split client provided' do
    before do
      ThisFeature.configure do |config|
        config.adapters = [adapter]
      end
    end

    context 'when turned on globally' do
      let(:flag_name) { :on_feature }

      it 'is on for everyone' do
        expect(ThisFeature.flag(flag_name).on?).to be true
        expect(ThisFeature.flag(flag_name).off?).to be false
        expect(ThisFeature.flag(flag_name).control?).to be false

        expect(ThisFeature.flag(flag_name, context: org_id).on?).to be true
        expect(ThisFeature.flag(flag_name, context: org_id).off?).to be false
        expect(ThisFeature.flag(flag_name, context: org_id).control?).to be false

        expect(ThisFeature.flag(flag_name, context: another_org_id).on?).to be true
        expect(ThisFeature.flag(flag_name, context: another_org_id).off?).to be false
        expect(ThisFeature.flag(flag_name, context: another_org_id).control?).to be false

        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).on?).to be true
        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).off?).to be false
        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).control?).to be false
      end
    end

    context 'when turned on for specific keys' do
      let(:flag_name) { :partially_on_feature }

      it 'is on for specific orgs' do
        expect(ThisFeature.flag(flag_name).on?).to be false
        expect(ThisFeature.flag(flag_name).off?).to be false
        expect(ThisFeature.flag(flag_name).control?).to be true

        expect(ThisFeature.flag(flag_name, context: org_id).on?).to be true
        expect(ThisFeature.flag(flag_name, context: org_id).off?).to be false
        expect(ThisFeature.flag(flag_name, context: org_id).control?).to be false

        expect(ThisFeature.flag(flag_name, context: another_org_id).on?).to be false
        expect(ThisFeature.flag(flag_name, context: another_org_id).off?).to be false
        expect(ThisFeature.flag(flag_name, context: another_org_id).control?).to be true

        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).on?).to be true
        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).off?).to be false
        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).control?).to be false
      end
    end

    context 'when turned off globally' do
      let(:flag_name) { :off_feature }

      it 'is off for everyone' do
        expect(ThisFeature.flag(flag_name).on?).to be false
        expect(ThisFeature.flag(flag_name).off?).to be true
        expect(ThisFeature.flag(flag_name).control?).to be false

        expect(ThisFeature.flag(flag_name, context: org_id).on?).to be false
        expect(ThisFeature.flag(flag_name, context: org_id).off?).to be true
        expect(ThisFeature.flag(flag_name, context: org_id).control?).to be false

        expect(ThisFeature.flag(flag_name, context: another_org_id).on?).to be false
        expect(ThisFeature.flag(flag_name, context: another_org_id).off?).to be true
        expect(ThisFeature.flag(flag_name, context: another_org_id).control?).to be false

        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).on?).to be false
        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).off?).to be true
        expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).control?).to be false
      end
    end
  end

  context 'without split client provided' do
    let(:adapter) { described_class.new }
    let(:client_double) { instance_double(SplitIoClient::SplitClient) }

    before do
      allow_any_instance_of(described_class).to receive(:default_split_client).and_return(client_double)
      allow(client_double).to receive(:block_until_ready)

      ThisFeature.configure { |config| config.adapters = [adapter] }
    end

    it 'uses default split client' do
      expect(adapter.send(:client)).to eq(client_double)
    end
  end

  context 'with context key method' do
    let(:adapter) { described_class.new(client: split_client, context_key_method: :context_key) }
    let(:context) { OpenStruct.new(context_key: context_value) }
    let(:context_value) { '1' }
    let(:another_context) { OpenStruct.new }

    let(:flag_name) { :partially_on_feature }

    before do
      ThisFeature.configure do |config|
        config.adapters = [adapter]
      end
    end

    context 'when turned on for specific keys' do
      it 'is uses the context key method to look up the context key' do
        expect(ThisFeature.flag(flag_name).on?).to be false
        expect(ThisFeature.flag(flag_name).off?).to be false
        expect(ThisFeature.flag(flag_name).control?).to be true

        expect(ThisFeature.flag(flag_name, context: context).on?).to be true
        expect(ThisFeature.flag(flag_name, context: context).off?).to be false
        expect(ThisFeature.flag(flag_name, context: context).control?).to be false

        expect(ThisFeature.flag(flag_name, context: another_context).on?).to be false
        expect(ThisFeature.flag(flag_name, context: another_context).off?).to be false
        expect(ThisFeature.flag(flag_name, context: another_context).control?).to be true

        expect(ThisFeature.flag(flag_name, context: context, data: { a: :b }).on?).to be true
        expect(ThisFeature.flag(flag_name, context: context, data: { a: :b }).off?).to be false
        expect(ThisFeature.flag(flag_name, context: context, data: { a: :b }).control?).to be false
      end
    end

    context 'when context doesn’t respond to context key method' do
      let(:context) { 'some string' }

      it 'raises an exception' do
        expect { ThisFeature.flag(flag_name, context: context).on? }.to raise_error(NoMethodError)
      end
    end
  end

  context 'with record and base_data_lambda' do
    # The Split localhost mode only supports using the key/context and not
    # additional attributes/data. That's why these tests just check that the
    # receiver gets the expected values while the above tests verify outcome.
    let(:flag_name) { :partially_on_feature }
    let(:record) { OpenStruct.new(id: 123, org_id: 99) }

    before do
      ThisFeature.configure { |config| config.adapters = [adapter] }
      allow(ThisFeature).to receive(:adapter_for).and_return(adapter)
      allow(ThisFeature).to receive(:base_data_lambda).and_return(
        lambda do |record|
          {
            org_id: record.org_id.to_s,
            user_id: record.id.to_s
          }
        end
      )
    end

    context 'with only record provided' do
      it 'sends record attributes in data hash' do
        %i[on? off? control?].each do |method|
          expect(split_client).to(
            receive(:get_treatment)
            .with('undefined_key', flag_name, { org_id: '99', user_id: '123' })
            .and_call_original
          )

          ThisFeature.flag(flag_name, record: record).public_send(method)
        end
      end
    end

    context 'with record and data provided' do
      it 'sends record attributes merged with data in data hash' do
        %i[on? off? control?].each do |method|
          expect(split_client).to(
            receive(:get_treatment)
            .with('undefined_key', flag_name, { foo: :bar, org_id: '99', user_id: '123' })
            .and_call_original
          )

          ThisFeature.flag(flag_name, record: record, data: { foo: :bar }).public_send(method)
        end
      end
    end

    context 'with record and context provided' do
      it 'sends context and record attributes in data hash' do
        %i[on? off? control?].each do |method|
          expect(split_client).to(
            receive(:get_treatment)
            .with('foo', flag_name, { org_id: '99', user_id: '123' })
            .and_call_original
          )

          ThisFeature.flag(flag_name, context: 'foo', record: record).public_send(method)
        end
      end
    end
  end
end
