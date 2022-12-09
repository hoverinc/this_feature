require 'splitclient-rb'

class ThisFeature
  module Adapters
    class SplitIo < Base
      # Used as the context key when none is given. This arg is required by
      # Split, but it's nice not to have to pass it when the context is empty.
      EMPTY_CONTEXT = 'undefined_key'

      def initialize(client: nil, context_key_method: nil)
        @client = client || default_split_client
        @context_key_method = context_key_method

        @client.block_until_ready
      end

      def present?(flag_name)
        !control?(flag_name)
      end

      def control?(flag_name, context: EMPTY_CONTEXT, data: {}, record: nil)
        treatment(flag_name, context: context, data: data, record: record).include?('control')
      end

      def on?(flag_name, context: EMPTY_CONTEXT, data: {}, record: nil)
        treatment(flag_name, context: context, data: data, record: record).eql?('on')
      end

      def off?(flag_name, context: EMPTY_CONTEXT, data: {}, record: nil)
        treatment(flag_name, context: context, data: data, record: record).eql?('off')
      end

      private

      attr_reader :client, :context_key_method

      def treatment(flag_name, context: EMPTY_CONTEXT, data: {}, record: nil)
        base_data = record ? ThisFeature.base_data_lambda.call(record) : {}
        client.get_treatment(context_key(context), flag_name, base_data.merge(data))
      end

      def context_key(context)
        return EMPTY_CONTEXT if context.nil? || context.eql?(EMPTY_CONTEXT)
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
