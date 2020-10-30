class ThisFeature
  module Adapters
    class Memory < Base

      def initialize(context_key_method: nil)
        @context_key_method = context_key_method
      end

      def clear
        storage.clear
      end

      def present?(flag_name)
        !storage[flag_name].nil?
      end

      def on?(flag_name, context: nil, data: {})
        return false unless present?(flag_name)

        flag_data = storage[flag_name]

        return true if flag_data[:global]
        return false if context.nil?

        flag_data[:contexts] ||= {}

        !!flag_data[:contexts][context_key(context)]
      end

      def off?(flag_name, context: nil, data: {})
        on_result = on?(flag_name, context: context)

        return if on_result.nil?

        !on_result
      end

      def on!(flag_name, context: nil, data: {})
        storage[flag_name] ||= {}

        return storage[flag_name][:global] = true if context.nil?

        storage[flag_name][:contexts] ||= {}
        storage[flag_name][:contexts][context_key(context)] = true
      end

      def off!(flag_name, context: nil, data: {})
        storage[flag_name] ||= {}

        return storage[flag_name][:global] = false if context.nil?

        storage[flag_name][:contexts] ||= {}
        storage[flag_name][:contexts][context_key(context)] = false
      end

      def storage
        @storage ||= {}
      end

      private

      attr_reader :context_key_method

      def context_key(context)
        return context if context_key_method.nil?

        context.send(context_key_method)
      end
    end
  end
end
