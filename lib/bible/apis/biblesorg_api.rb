class BiblesorgApi
  API_KEY = ENV["API_KEY_BIBLESORG"]
  API_URL_TEXT = "https://bibles.org/v2/passages.js"

  # en      - eng-CEVD   - 2006 Contemporary English Version, Second Edition (US Version)
  # en      - eng-CEV    - 1996 Contemporary English Version (US Version)
  # en      - eng-GNTD   - 1992 Good News Translation, Second Edition (US Version) (with Deuterocanonicals/Apocrypha)
  # en-gb   - eng-CEVUK  - 1995 Contemporary English Version (Anglicised Version)
  # en-gb   - eng-GNBDC  - 1992 Good News Bible, Second Edition (Anglicised) (with Deuterocanonicals/Apocrypha)
  # en      - eng-MSG    - The Message
  # es-419  - spa-DHH    - 1994 Biblia Dios Habla Hoy (sin notas ni ayudas)
  # zh-Hans - zho-RCUVSS - 2010 Revised Chinese Union Version
  # fr      - fra-NBS    - 2002 Nouvelle Bible Segond
  # fr      - fra-PDV    - 2000 Parole de Vie
  # pt-BR   - por-NTLH   - 2000 Nova Tradução na Linguagem de Hoje
  # pt      - por-BPT09

  def initialize(version)
    @version = version
  end

  def version
    @version
  end

  def lookup(bible_ref)
    url = "#{API_URL_TEXT}?version=#{@version}&q[]=#{URI::encode(bible_ref)}"
    creds = { :username => API_KEY, :password => "X" }
    response = HTTParty.get(url, :basic_auth => creds)
    response_json = JSON.parse(response.body)
    passage_info = response_json["response"]["search"]["result"]["passages"][0]
    raise "Bibles.org did not provide a passage for #{bible_ref}" if passage_info.blank?
    passage_info.merge!({
      "tracking" => response_json["response"]["meta"]["fums_noscript"]
    })
    passage_info
  end

  def get_text(bible_ref)
    passage = lookup(bible_ref)
    {
      :text => _transpose_text(passage["text"]),
      :tracking_code => passage["tracking"],
      :copyright => _transpose_copyright(passage["copyright"]),
      :css => "biblesorg-api"
    }
  end

  def get_audio(bible_ref)
    nil
  end

  def get_read_more(bible_ref)
    "http://bibles.org/search/#{bible_ref}/#{@version}"
  end

  def _transpose_text(text)
    text
      .gsub("<sup", " <sup")
      .gsub("</sup>", "</sup> ")
      .gsub("[Lord]", "<span class=\"lord\">Lord</span>")
  end

  def _transpose_copyright(copyright)
    copyright
      .gsub(" &#169;", "<br/>&#169;")
  end
end
