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

    def get_treatment
      adapter.get_treatment(flag_name, record: record)
    end
  end
end
