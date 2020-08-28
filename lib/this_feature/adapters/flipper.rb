require "flipper"
require "flipper/adapters/active_record"

class ThisFeature
  module Adapters
    class Flipper < Base
      attr_reader :client

      def initialize(client: nil)
        @client = client || default_flipper_adapter
      end

      def present?(flag_name)
        client[flag_name].exist?
      end

      def control?(flag_name, **kwargs)
        !present?(flag_name)
      end

      def on?(flag_name, context: nil, data: {})
        return unless present?(flag_name)

        client[flag_name].enabled?(*[context].compact)
      end

      def off?(flag_name, context: nil, data: {})
        on_result = on?(flag_name, context: context)

        return if on_result.nil?

        !on_result
      end

      def on!(flag_name, context: nil, data: {})
        client[flag_name].enable(*[context].compact)
      end

      def off!(flag_name, context: nil, data: {})
        client[flag_name].disable(*[context].compact)
      end

      private

      def default_flipper_adapter
        ::Flipper.configure do |config|
          config.default do
            adapter = ::Flipper::Adapters::ActiveRecord.new
            ::Flipper.new(adapter)
          end
        end
        ::Flipper
      end
    end
  end
end
