class KuberKit::Core::ContextHelper::ServiceHelper < KuberKit::Core::ContextHelper::BaseHelper
  def initialize(image_store:, artifact_store:, shell:, service:)
    super(
      image_store:    image_store, 
      artifact_store: artifact_store, 
      shell:          shell
    )
    @service = service
  end

  def service_name
    @service.name.to_s
  end

  def service_uri
    @service.uri
  end

  def attribute(attribute_name)
    @service.attribute(attribute_name)
  end
end