require_relative "../app/stories"

get "/" do
  stories = Stories.load("stories.csv").values
  erb :index, :locals => {
    :stories => stories
  }
end
