require_relative "bible/passage"

class Account
  attr_reader :story, :id, :passage

  def initialize(story, id, book_key, book_ref)
    @story = story
    @id = id
    @passage = Passage.new(book_key, book_ref)
  end

  def other_accounts
    self.story.accounts.select { |account| account.id != @id }
  end

  def title
    self.story.title
  end

  def url(locale: I18n.locale, base_url: nil)
    url = I18n.t("story.url.#{self.id}", :locale => locale, :default => self.id)
    url = "#{base_url}/#{url}" if base_url
    url
  end

  def short_url(locale: I18n.locale, base_url: nil)
    short_url = I18n.t("story.url.#{self.id}", :locale => locale, :default => self.id)
    short_url = "#{base_url}/#{short_url}" if base_url
    short_url
  end

  def as_json(options = {})
    {
      :id => self.id,
      :type => self.class.name.downcase,
      :title => self.title,
      :bible_ref => self.passage.bible_ref,
      :bible_ref_english => self.passage.bible_ref_english,
      :author => self.passage.author,
      :url => self.url(locale: options[:locale], base_url: options[:base_url]),
      :short_url => self.short_url(locale: options[:locale], base_url: options[:base_url_short])
    }
  end
end
