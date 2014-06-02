
get "/pitch" do
  stories = Stories.load("stories.csv").values
  hello = nil
  exception = hello[0]
  erb :pitch
end
