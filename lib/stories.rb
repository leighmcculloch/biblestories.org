require "csv"
require_relative "story"
require_relative "account"

class Stories
  @stories = {}

  def self.all
    return @stories[I18n.locale] if @stories[I18n.locale]

    csv = CSV.read("data/stories.csv", { :col_sep => "," })
    csv = csv.map { |story| story.map { |story_property| story_property.strip } }

    stories = {}

    csv.each do |line|
      story_id = line[0].strip
      story_account_id = line[1].strip
      story_book_key = line[2].strip
      story_book_ref = line[3].strip

      story = (stories[story_id] ||= Story.new(story_id))
      story_account = Account.new(story, story_account_id, story_book_key, story_book_ref)
      story.accounts << story_account
    end

    @stories[I18n.locale] = stories
  end

  def self.all_accounts
    story_accounts = {}
    self.all.each do |_, story|
      story.accounts.each do |story_account|
        story_accounts[story_account.id] = story_account
      end
    end
    story_accounts
  end
end
