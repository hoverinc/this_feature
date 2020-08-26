class ThisFeature
  module Adapters
    class Base

      def self.setup
        raise UnimplementedError.new(self, __method__)
      end

      def self.present?(flag_name)
        raise UnimplementedError.new(self, __method__)
      end

      def self.on?(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.off?(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.on!(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.off!(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      # OPTIONAL method
      # check to see if a control is being used
      def self.control?(flag_name, context: nil, data: {})
        false
      end
    end
  end
end
