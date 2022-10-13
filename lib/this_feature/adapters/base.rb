class ThisFeature
  module Adapters
    class Base
      def present?(flag_name)
        raise UnimplementedError.new(self, __method__)
      end

      def on?(flag_name, context: nil, data: {}, record: nil)
        raise UnimplementedError.new(self, __method__)
      end

      def off?(flag_name, context: nil, data: {}, record: nil)
        raise UnimplementedError.new(self, __method__)
      end

      # OPTIONAL method
      # check to see if a control is being used
      def control?(flag_name, context: nil, data: {})
        false
      end
    end
  end
end
