Bundler.require :default, ENV['RACK_ENV']

class Web < Sinatra::Application
  set :root, File.dirname(__FILE__)
end

require_relative "controllers/app_controller"
