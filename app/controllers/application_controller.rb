class ApplicationController < ActionController::API
  private

  def permitted_params
    model_name = self.class.name.chomp('Controller').singularize.constantize
    serializer = "#{model_name}Serializer".constantize
    permitted_attributes = serializer._attributes

    params.fetch(:data, {}).permit(*permitted_attributes)
  rescue NameError => e
    raise "Error determining permitted parameters: #{e.message}"
  end
end
