class FFeature
  class Flag
    def initialize(flag_name, adapter:, context: nil, data: {})
      @flag_name = flag_name
      @adapter = adapter
      @context = context
      @data = data
    end

    def on?
      adapter.on?(flag_name, context: @context)
    end

    def off?
      adapter.off?(flag_name, context: @context)
    end

    def control?
      adapter.control?(flag_name, context: @context)
    end

    def on!
      adapter.on!(flag_name, context: @context)
    end

    def off!
      adapter.off!(flag_name, context: @context)
    end

    private

    attr_reader :flag_name, :control, :data, :adapter
  end
end
