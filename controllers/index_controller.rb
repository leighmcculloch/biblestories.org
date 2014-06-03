require_relative "../app/stories"

class Web < Sinatra::Application
  get "/" do
    stories = Stories.load("stories.csv").values
    erb :index, :locals => {
      :stories => stories
    }
  end
end
