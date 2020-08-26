class ThisFeature

  class Error < StandardError; end

  class UnimplementedError < Error
    def initialize(klass, fn_name)
      super("class #{klass.name} doesnt implement method .#{fn_name}")
    end
  end

  class BadAdapterError < Error
    def initialize(adapter)
      super("adapter #{adapter.name} doesn't inherit from ThisFeature::Adapters::Base")
    end
  end

  class NoWriteAdapter < Error
    def initialize
      super("Use the `ThisFeature.write_adapter=` setter before calling #enable or #disable")
    end
  end

end