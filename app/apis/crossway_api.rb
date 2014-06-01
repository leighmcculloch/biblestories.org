require "httparty"

class CrosswayApi
  API_KEY = "IP"
  API_URL = "http://www.esvapi.org/v2/rest/passageQuery?key=#{API_KEY}"
  API_URL_AUDIO = "#{API_URL}" <<
      "&output-format=mp3" <<
      "&passage="
  API_URL_TEXT = "#{API_URL}" <<
      "&include-passage-references=true" <<
      "&include-first-verse-numbers=true" <<
      "&include-footnotes=false" <<
      "&include-footnote-links=false" <<
      "&include-surrounding-chapters=false" <<
      "&include-headings=false" <<
      "&include-subheadings=false" <<
      "&include-short-copyright=false" <<
      "&audio-format=flash" <<
      "&passage="

  def self.get_text(bible_ref)
    url = "#{API_URL_TEXT}#{URI::encode(bible_ref)}"
    response = HTTParty.get(url)
    {
        :text => response.body,
        :copyright => I18n.t(:crossway_text_copyright),
        :css => "crossway",
    }
  end

  def self.get_audio(bible_ref)
    {
      :audio_url => "#{API_URL_AUDIO}#{bible_ref}",
      :copyright => I18n.t(:crossway_audio_copyright),
    }
  end

  def self.get_read_more(bible_ref)
    "http://www.gnpcb.org/esv/search/?q=#{bible_ref}"
  end
end