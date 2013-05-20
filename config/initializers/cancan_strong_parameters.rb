module CanCan
  class ControllerResource
    
    def resource_params_with_strong_parameters
      if @controller.respond_to?(:resource_params, true)
        @controller.send(:resource_params) 
      else
        resource_params_without_strong_parameters
      end
    end
    
    alias_method_chain :resource_params, :strong_parameters
  end
end

