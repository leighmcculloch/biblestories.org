require_relative "apis"

class PassageVersion
  def self.load_versions(book_key, book_ref)
    bible_ref_english = Passage.bible_ref_english(book_key, book_ref)

    Apis.get_version_count.times.map do |version|
      text = Apis.get_text(bible_ref_english, version: version)
      text[:read_more_url] = Apis.get_read_more(bible_ref_english, version: version)
      audio = Apis.get_audio(bible_ref_english, version: version)
      PassageVersion.new(book_key, book_ref, text, audio)
    end
  end

  attr_reader :text_html, :text_copyright, :text_css, :read_more_url
  attr_reader :audio_url, :audio_info, :audio_copyright, :audio_css

  def initialize(book_key, book_ref, text, audio)
    @book_key = book_key
    @book_ref = book_ref

    if text
      @text_html = text[:text]
      @text_copyright = text[:copyright]
      @text_css = text[:css]
      @read_more_url = text[:read_more_url]
    end

    if audio
      bible_ref = Passage.bible_ref(book_key, book_ref)
      @audio_url = audio[:audio_url]
      @audio_info = audio[:audio_info] || (@audio_url && [ { :bible_ref => bible_ref, :url => @audio_url } ])
      @audio_copyright = audio[:copyright]
    end
  end

  def text_plain
    Sanitize.clean(self.text_html).strip
  end

  def text_plain_short
    "#{self.text_plain[0..197]}..."
  end
end
