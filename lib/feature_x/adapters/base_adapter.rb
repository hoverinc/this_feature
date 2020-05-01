class FeatureX
  module Adapters
    class BaseAdapter

      # =======================================================
      # Class-level API (used internally)
      # =======================================================

      def self.setup
        raise UnimplementedError.new(self, __method__)
      end

      def self.enabled?(flag_name)
        raise UnimplementedError.new(self, __method__)
      end

    end
  end
end