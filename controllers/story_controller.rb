require_relative "../app/stories"

get "/:story_short_url" do
  story_short_url = params[:story_short_url]
  stories = Stories.load("stories.csv")
  story = stories[story_short_url]
  
  return halt(404) if story.nil?
  
  erb :story, :locals => {
    :story => story
  }
end
