require "csv"
require_relative "story"

class Stories
  
  def self.load(file)
    default_file = "data/#{I18n.default_locale}.csv"
    locale_file = "data/#{I18n.locale}.csv"
    locale_file = default_file unless File.exists?(locale_file)

    stories_text = CSV.read(locale_file, { :col_sep => "," })
    stories_text = stories_text.map { |story| story.map { |story_property| story_property.strip } }
    
    stories = {}
    stories_text.each do |story_text|
      story = Story.new(story_text[0], story_text[1], story_text[2], story_text[3])
      stories.merge!(story.short_url => story)
    end
    
    stories
  end
  
end