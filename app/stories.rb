require "csv"
require_relative "story"

class Stories
  
  def self.load(file)
    stories_text = CSV.read("data/stories.csv", { :col_sep => "," })
    stories_text = stories_text.map { |story| story.map { |story_property| story_property.strip } }
    
    stories = {}
    stories_text.each do |story_text|
      story_key = story_text[0]
      story_book_key = story_text[1]
      story_book_ref = story_text[2]
      story = Story.new(story_key, story_book_key, story_book_ref)
      stories.merge!(story.short_url => story)
    end
    
    stories
  end
  
end