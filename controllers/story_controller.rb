require_relative "../app/stories"

class Web < Sinatra::Application
  get "/:story_key" do
    story_key = params[:story_key]
    story = Stories.find(story_key)

    return halt(404) if story.nil?

    erb :story, :locals => {
      :story => story
    }
  end
end
