require_relative "apis"

class PassageVersion
  def self.load_versions(book_key, book_ref)
    Apis.get_version_count.times.map do |version|
      PassageVersion.new(book_key, book_ref, version: version)
    end
  end

  def initialize(book_key, book_ref, version:)
    @book_key = book_key
    @book_ref = book_ref
    @version = version
  end

  def load
    text = Apis.get_text(self.bible_ref_english, version: @version)
    if text
      @text_html = text[:text]
      @text_tracking_code = text[:tracking_code]
      @text_copyright = text[:copyright]
      @text_css = text[:css]
      @read_more_url = Apis.get_read_more(bible_ref_english, version: @version)
    end

    audio = Apis.get_audio(self.bible_ref_english, version: @version)
    if audio
      @audio_url = audio[:audio_url]
      @audio_info = audio[:audio_info] || (@audio_url && [ { :bible_ref => self.bible_ref, :url => @audio_url } ])
      @audio_copyright = audio[:copyright]
    end
  end

  def text_html
    load
    @text_html
  end

  def text_tracking_code
    load
    @text_tracking_code
  end

  def text_copyright
    load
    @text_copyright
  end

  def text_css
    load
    @text_css
  end

  def read_more_url
    load
    @read_more_url
  end

  def audio_url
    load
    @audio_url
  end

  def audio_info
    load
    @audio_info
  end

  def audio_copyright
    load
    @audio_copyright
  end

  def text_plain
    Sanitize.clean(self.text_html).strip
  end

  def text_plain_short
    "#{self.text_plain[0..197]}..."
  end

  def bible_ref_english
    Passage.bible_ref_english(@book_key, @book_ref)
  end

  def bible_ref
    Passage.bible_ref(@book_key, @book_ref)
  end
end
