
get "/pitch" do
  stories = Stories.load("stories.csv").values
  erb :pitch
end
