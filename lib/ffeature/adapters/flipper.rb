require "flipper"
require "flipper/adapters/active_record"

class FFeature
  module Adapters
    class Flipper < Base

      def self.setup
        ::Flipper.configure do |config|
          config.default do
            adapter = ::Flipper::Adapters::ActiveRecord.new
            ::Flipper.new(adapter)
          end
        end
      end

      def self.enabled?(flag_name, context: nil)
        ::Flipper[flag_name].enabled?(*[context].compact)
      end

      def self.enable(flag_name, context: nil)
        ::Flipper[flag_name].enable(*[context].compact)
      end

      def self.disable(flag_name, context: nil)
        ::Flipper[flag_name].disable(*[context].compact)
      end

    end
  end
end
