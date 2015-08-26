module ActiveMerchant
  module Billing
    class Response
      ATTRIBUTES_FOR_MONGOID_OPTIONS_SERIALIZATION = [
        :test,
        :authorization,
        :fraud_review,
        :error_code,
        :emv_authorization,
        :avs_result
      ]

      def mongoize
        options = ATTRIBUTES_FOR_MONGOID_OPTIONS_SERIALIZATION.reduce({}) do |result, attr|
          value = instance_variable_get(:"@#{attr}")
          result[attr.to_s] = value unless value.nil?
          result
        end

        # ActiveMerchant::Billing::CvvResult doesn't take a hash to initialize,
        # but it sets the Response's cvv_result instance variable to a hash.
        options['cvv_result'] = @cvv_result['code'] if @cvv_result.present?

        {
          'success' => success?,
          'message' => message,
          'params' => params,
          'options' => options
        }
      end

      class << self
        def demongoize(object)
          return nil if object.blank?

          options = object['options'].symbolize_keys

          if options[:avs_result].present?
            options[:avs_result] = options[:avs_result].symbolize_keys
          end

          Response.new(
            object['success'],
            object['message'],
            object['params'],
            options
          )
        end

        def mongoize(object)
          case object
          when Response then object.mongoize
          else object
          end
        end

        def evolve(object)
          raise 'querying on an ActiveMerchant::Billing::Response is unsupported at this time'
        end
      end
    end
  end
end
