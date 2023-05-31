class ThisFeature
  class Error < StandardError; end

  class UnimplementedError < Error
    def initialize(adapter_instance, fn_name)
      super("class #{adapter_instance.class.name} doesn't implement method .#{fn_name}")
    end
  end

  class BadAdapterError < Error
    def initialize(adapter_instance)
      super("adapter #{adapter_instance.class.name} doesn't inherit from #{ThisFeature::Adapters::Base.name}")
    end
  end

  class NoAdaptersError < Error
    def initialize
      super('No adapters configured.')
    end
  end
end
