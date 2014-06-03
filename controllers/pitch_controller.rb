class Web < Sinatra::Application
  get "/pitch" do
    erb :pitch
  end
end
