class FFeature
  class Flag
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

    private

    attr_reader :flag_name, :context, :data, :adapter
  end
end
