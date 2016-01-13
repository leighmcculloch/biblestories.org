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
      "&include-audio-link=false" <<
      "&audio-format=flash" <<
      "&passage="

  def version
    "ESV"
  end

  def get_text(bible_ref)
    url = "#{API_URL_TEXT}#{URI::encode(bible_ref)}"
    response = HTTParty.get(url)
    raise "Crossway did not return a passage for #{bible_ref}" if response.body =~ /no results/i
    {
        :text => response.body,
        :copyright => %(Scripture taken from The Holy Bible, English Standard Version and Copyright &copy;2001 by <a href="http://www.crosswaybibles.org">Crossway Bibles</a>, a publishing ministry of Good News Publishers. Used by permission. All rights reserved. Text provided by the <a href="http://www.gnpcb.org/esv/share/services/">Crossway Bibles Web Service</a>.),
        :css => "crossway",
    }
  end

  def get_audio(bible_ref)
    url = "#{API_URL_AUDIO}#{URI::encode(bible_ref)}"
    response = HTTParty.head(url, { :maintain_method_across_redirects => true })
    url = response.request.last_uri.to_s
    {
      :audio_url => url,
      :copyright => %(Audio provided by the <a href="http://www.gnpcb.org/esv/share/services/">Crossway Bibles Web Service</a>.),
    }
  end

  def get_read_more(bible_ref)
    "http://www.gnpcb.org/esv/search/?q=#{bible_ref}"
  end
end
