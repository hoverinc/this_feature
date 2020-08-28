require 'splitclient-rb'

class ThisFeature
  module Adapters
    class SplitIo < Base
      class << self

      def setup(factory:)
        @@factory = factory
        client.block_until_ready
      rescue SplitIoClient::SDKBlockerTimeoutExpiredException
        raise 'Split SDK is not ready. Abort execution.'
      end

      def present?(flag_name)
        !control?(flag_name, context: 'undefined')
      end

      def control?(...)
        treatment(...).eql?('control')
      end

      def on?(...)
        treatment(...).eql?('on')
      end

      def off?(...)
        treatment(...).eql?('off')
      end

      def on!(...)
      end

      def off!(...)
      end

      def treatment(flag_name, context:, data: {})
        key = context.respond_to?(:to_s) ? context.to_s : context
        client.get_treatment(key, flag_name, attributes)[:treatment]
      end

      def client
        @@client ||= factory.client
      end

      def factory
        @@factory
      end
    end
  end
end
