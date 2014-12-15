class Deployments
  include Enumerable

  attr_accessor :deployments

  def initialize(deployments:)
    @deployments = deployments
  end

  def [](index)
    self.deployments[index]
  end

  def each(&block)
    @deployments.each(&block)
  end

  def locales
    self.deployments.inject([]) { |locales, deployment| locales.concat(deployment.locales) }
  end

  def host(locale:)
    deployment = deployment_for(locale: locale)
    deployment.host if deployment
  end

  def host_short(locale:)
    deployment = deployment_for(locale: locale)
    deployment.host_short if deployment
  end

  def base_url(locale:)
    deployment = deployment_for(locale: locale)
    deployment.base_url if deployment
  end

  def base_url_short(locale:)
    deployment = deployment_for(locale: locale)
    deployment.base_url_short if deployment
  end

  private

  def deployment_for(locale:)
    @deployments.find { |deployment| deployment.locales.include?(locale) }
  end

end