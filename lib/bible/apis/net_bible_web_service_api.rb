class NetBibleWebServiceApi
  API_URL_TEXT = "http://labs.bible.org/api/"

  def version
    "NET"
  end

  def _lookup_passage_html(bible_ref)
    url = "#{API_URL_TEXT}?formatting=full&passage=#{URI::encode(bible_ref)}"
    response = HTTParty.get(url)
    passage_html = response.body
    raise "#{self.class.name} did not provide a passage for #{bible_ref}" if passage_html.blank?
    passage_html
  end

  def get_text(bible_ref)
    passage_html = _lookup_passage_html(bible_ref)
    {
      :text => _transpose_text(passage_html),
      :copyright => "Scripture quoted by permission. All scripture quotations, unless otherwise indicated, are taken from the NET Bible&reg; copyright &copy;1996-2006 by Biblical Studies Press, L.L.C. http://netbible.com All rights reserved.",
      :css => "net-bible-web-service-api",
    }
  end

  def get_audio(bible_ref)
    nil
  end

  def get_read_more(bible_ref)
    "https://lumina.bible.org/bible/#{bible_ref}"
  end

  def _transpose_text(text)
    text.gsub(%r{<n id="\d+" />}, "")
  end
end
