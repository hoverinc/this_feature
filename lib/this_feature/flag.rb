class ThisFeature
  class Flag
    attr_reader :flag_name, :context, :data, :adapter

    def initialize(flag_name, adapter:, context: nil, data: {})
      @flag_name = flag_name
      @adapter = adapter
      @context = context
      @data = data
    end

    def on?
      adapter.on?(flag_name, context: context, data: data)
    end

    def off?
      adapter.off?(flag_name, context: context, data: data)
    end

    def control?
      adapter.control?(flag_name, context: context, data: data)
    end

    def on!
      adapter.on!(flag_name, context: context, data: data)
    end

    def off!
      adapter.off!(flag_name, context: context, data: data)
    end
  end
end
