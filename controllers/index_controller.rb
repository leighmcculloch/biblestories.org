require_relative "../app/stories"

class Web < Sinatra::Application
  get "/" do
    stories = Stories.all.values
    erb :index, :locals => {
      :stories => stories
    }
  end
end
