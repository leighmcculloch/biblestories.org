require "csv"
require_relative "story"

class Stories
  @stories = {}
  
  def self.all
    return @stories[I18n.locale] if @stories[I18n.locale]

    stories_csv = CSV.read("data/stories.csv", { :col_sep => "," })
    stories_csv = stories_csv.map { |story| story.map { |story_property| story_property.strip } }
    
    stories_pair_array = stories_csv.map do |story_csv_line|
      story_key = story_csv_line[0].strip
      story_book_key = story_csv_line[1].strip
      story_book_ref = story_csv_line[2].strip
      story = Story.new(story_key, story_book_key, story_book_ref)
      [story.short_url, story]
    end

    @stories[I18n.locale] = Hash[stories_pair_array]
  end

  def self.find(story_key)
    self.all[story_key]
  end
  
end