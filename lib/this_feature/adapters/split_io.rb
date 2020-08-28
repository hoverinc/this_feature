require 'splitclient-rb'

class ThisFeature
  module Adapters
    class SplitIo < Base
      UNDEFINED_KEY = 'undefined_key'

      def initialize(client:)
        @client = client
        client.block_until_ready
      rescue SplitIoClient::SDKBlockerTimeoutExpiredException
        raise 'Split SDK is not ready. Abort execution.'
      end

      def present?(flag_name)
        !control?(flag_name)
      end

      def control?(flag_name, context: UNDEFINED_KEY, data: {})
        treatment(flag_name, context: context, data: data).eql?('control_treatment')
      end

      def on?(flag_name, context: UNDEFINED_KEY, data: {})
        treatment(flag_name, context: context, data: data).eql?('on')
      end

      def off?(flag_name, context: UNDEFINED_KEY, data: {})
        treatment(flag_name, context: context, data: data).eql?('off')
      end

      private

      attr_reader :client

      def treatment(flag_name, context: UNDEFINED_KEY, data: {})
        key = if context.nil?
          UNDEFINED_KEY
        elsif context.respond_to?(:to_s)
          context.to_s
        else
          context
        end

        client.get_treatment(key, flag_name, data)
      end
    end
  end
end
