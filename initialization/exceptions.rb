class Web < Sinatra::Application

  configure :production, :staging do
    use Bugsnag::Rack
    enable :raise_errors
  end

end
