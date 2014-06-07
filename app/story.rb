require_relative "apis"

class Story
  attr_reader :short_url, :title, :bible_ref, :bible_ref_english

  def initialize(short_url, title, bible_ref, bible_ref_english)
    @short_url = short_url
    @title = title
    @bible_ref = bible_ref
    @bible_ref_english = bible_ref_english
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
    Sanitize.clean(self.text_html)
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
end