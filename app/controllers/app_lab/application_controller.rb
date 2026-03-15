module AppLab
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :authenticate_app_lab_user!

    layout "app_lab/application"

    private

    def authenticate_app_lab_user!
      return unless AppLab.configuration.authentication_enabled

      method = AppLab.configuration.authentication_method
      case method
      when Proc
        instance_exec(&method)
      when Symbol
        send(method)
      when nil
        # No authentication configured — allow access
      else
        raise "Invalid authentication_method: #{method.class}. Expected Proc, Symbol, or nil."
      end
    end

    def render_inertia(component, props: {})
      render inertia: component, props: props
    end
  end
end
