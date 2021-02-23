require 'splitclient-rb'

class ThisFeature
  module Adapters
    class SplitIo < Base
      # used as treatment key when none is given, it's required by split
      UNDEFINED_KEY = 'undefined_key'

      def initialize(client: nil, context_key_method: nil)
        @client = client || default_split_client
        @context_key_method = context_key_method

        @client.block_until_ready
      end

      def present?(flag_name)
        !control?(flag_name)
      end

      def control?(flag_name, context: UNDEFINED_KEY, data: {})
        treatment(flag_name, context: context, data: data).include?('control')
      end

      def on?(flag_name, context: UNDEFINED_KEY, data: {})
        treatment(flag_name, context: context, data: data).eql?('on')
      end

      def off?(flag_name, context: UNDEFINED_KEY, data: {})
        treatment(flag_name, context: context, data: data).eql?('off')
      end

      private

      attr_reader :client, :context_key_method

      def treatment(flag_name, context: UNDEFINED_KEY, data: {})
        client.get_treatment(context_key(context), flag_name, data)
      end

      def context_key(context)
        return UNDEFINED_KEY if context.nil? || context.eql?(UNDEFINED_KEY)
        return context.send(context_key_method) unless context_key_method.nil?
        return context.to_s if context.respond_to?(:to_s)

        context
      end

      def default_split_client
        SplitIoClient::SplitFactory.new(ENV.fetch('SPLIT_IO_AUTH_KEY')).client
      end
    end
  end
end
