require 'this_feature/version'
require 'this_feature/adapters'
require 'this_feature/errors'
require 'this_feature/configuration'
require 'this_feature/flag'

class ThisFeature
  def self.flag(flag_name, context: nil, data: {}, record: nil)
    adapter = adapter_for(flag_name)

    Flag.new(flag_name, adapter: adapter, context: context, data: data, record: record)
  end

  def self.adapter_for(flag_name)
    matching_adapter = adapters.find do |adapter|
      adapter.present?(flag_name)
    end

    matching_adapter || configuration.default_adapter
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    @configuration = Configuration.new

    yield(configuration)

    configuration.init
  end

  def self.adapters
    configuration.adapters
  end

  def self.test_adapter
    configuration.test_adapter
  end

  def self.base_data_lambda
    configuration.base_data_lambda
  end
end
