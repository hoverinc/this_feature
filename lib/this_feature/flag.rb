class ThisFeature
  class Flag
    attr_reader :flag_name, :context, :data, :adapter, :record

    def initialize(flag_name, adapter:, context: nil, data: {}, record: nil)
      @flag_name = flag_name
      @adapter = adapter
      @context = context
      @data = data
      @record = record
    end

    def on?
      adapter.on?(flag_name, context: context, data: data, record: record)
    end

    def off?
      adapter.off?(flag_name, context: context, data: data, record: record)
    end

    def control?
      adapter.control?(flag_name, context: context, data: data, record: record)
    end

    def treatment_value
      adapter.treatment_value(flag_name, context: context, data: data, record: record)
    end

    def treatment_config
      adapter.treatment_config(flag_name, context: context, data: data, record: record)
    end
  end
end
