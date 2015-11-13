require_relative "apis"

class Account
  attr_reader :story, :id

  def initialize(story, id, book_key, book_ref)
    @story = story
    @id = id
    @book_key = book_key
    @book_ref = book_ref
  end

  def title
    self.story.title
  end

  def author
    I18n.translate!("bible_book_author.#{@book_key}")
  rescue I18n::MissingTranslationData
    nil
  end

  def bible_ref
    "#{I18n.t("bible_book.#{@book_key}")} #{@book_ref}"
  end

  def bible_ref_english
    "#{I18n.t("bible_book.#{@book_key}", locale: :en)} #{@book_ref}"
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

  def load
    return if @loaded
    @loaded = true

    text = Apis.get_text(self.bible_ref_english)
    if text
      @text_html = text[:text]
      @text_copyright = text[:copyright]
      @text_css = text[:css]
    end

    audio = Apis.get_audio(self.bible_ref_english)
    if audio
      @audio_url = audio[:audio_url]
      @audio_info = audio[:audio_info]
      @audio_copyright = audio[:copyright]
    end

    @read_more_url = Apis.get_read_more(self.bible_ref_english)
  end

  def text_plain
    Sanitize.clean(self.text_html).strip
  end

  def text_plain_short
    "#{self.text_plain[0..197]}..."
  end

  def text_html
    load
    @text_html
  end

  def text_copyright
    load
    @text_copyright
  end

  def text_css
    load
    @text_css
  end

  def audio_url
    load
    @audio_url
  end

  def audio_info
    load
    return @audio_info if @audio_info
    return [ { :bible_ref => self.bible_ref, :url => @audio_url } ] if @audio_url
    nil
  end

  def audio_copyright
    load
    @audio_copyright
  end

  def read_more_url
    load
    @read_more_url
  end

  def as_json(options = {})
    {
      :id => self.id,
      :type => self.class.name.downcase,
      :title => self.title,
      :bible_ref => self.bible_ref,
      :bible_ref_english => self.bible_ref_english,
      :author => self.author,
      :url => self.url(locale: options[:locale], base_url: options[:base_url]),
      :short_url => self.short_url(locale: options[:locale], base_url: options[:base_url_short])
    }
  end
end
