module AppLab
  module Api
    module V1
      class BaseController < ActionController::API
        before_action :authenticate_api_user!

        private

        def authenticate_api_user!
          return unless AppLab.configuration.authentication_enabled

          method = AppLab.configuration.authentication_method
          case method
          when Proc
            instance_exec(&method)
          when Symbol
            send(method)
          when nil
            # No auth configured
          end
        end
      end
    end
  end
end
