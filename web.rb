Bundler.require :default, ENV['RACK_ENV']

class Web < Sinatra::Application
  set :root, File.dirname(__FILE__)
end

require_relative "initialization/exceptions"
require_relative "initialization/caching"
require_relative "initialization/localization"
require_relative "initialization/controllers"
