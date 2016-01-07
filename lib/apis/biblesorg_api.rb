class BiblesorgApi
  API_KEY = ENV["API_KEY_BIBLESORG"]
  API_URL_TEXT = "https://bibles.org/v2/passages.js"

  LOCALE_TO_VERSION_MAP = {
    :"en" => "eng-CEVD", # 2006 Contemporary English Version, Second Edition (US Version)
    # :"en" => "eng-CEV", # 1995 Contemporary English Version (US Version)
    # :"en" => "eng-GNTD", # 1992 Good News Translation (US Version) (with Deuterocanonicals/Apocrypha)
    # :"en-gb" => "eng-CEVUK", # 1995 Contemporary English Version (Anglicised Version)
    # :"en-gb" => "eng-GNBDC", # 1992 Good News Bible (Anglicised) (with Deuterocanonicals/Apocrypha)
    :"es-419" => "spa-DHH", # 1994 Biblia Dios Habla Hoy (sin notas ni ayudas)
    :"zh-Hans" => "zho-RCUVSS", # 2010 Revised Chinese Union Version
    # :"fr" => "fra-NBS", # 2002 Nouvelle Bible Segond
    # :"fr" => "fra-PDV", # 2000 Parole de Vie
    # :"pt" => "por-BPT09",
    :"pt-BR" => "por-NTLH", # 2000 Nova Tradução na Linguagem de Hoje
  }

  def self.get_version_for_locale
    version = LOCALE_TO_VERSION_MAP[I18n.locale]
    raise "No version defined for locale #{I18n.locale}" if version.nil?
    version
  end

  def self.lookup(bible_ref)
    version = get_version_for_locale
    url = "#{API_URL_TEXT}?version=#{version}&q[]=#{URI::encode(bible_ref)}"
    creds = { :username => API_KEY, :password => "X" }
    response = HTTParty.get(url, :basic_auth => creds)
    response_json = JSON.parse(response.body)
    passage_info = response_json["response"]["search"]["result"]["passages"][0]
    raise "Bibles.org did not provide a passage for #{bible_ref}" if passage_info.blank?
    passage_info.merge!({
      "tracking" => response_json["response"]["meta"]["fums"]
    })
    passage_info
  end

  def self.get_text(bible_ref)
    passage = lookup(bible_ref)
    text = _transpose_text(passage["text"]) + passage["tracking"]
    copyright = _transpose_copyright(passage["copyright"])
    {
      :text => text,
      :copyright => copyright,
      :css => "biblesorg",
    }
  end

  def self.get_audio(bible_ref)
    nil
  end

  def self.get_read_more(bible_ref)
    "http://bibles.org/search/#{bible_ref}/#{get_version_for_locale}"
  end

  def self._transpose_text(text)
    text
      .gsub("<sup", " <sup")
      .gsub("</sup>", "</sup> ")
      .gsub("[Lord]", "<span class=\"lord\">Lord</span>")
  end

  def self._transpose_copyright(copyright)
    copyright
      .gsub(" &#169;", "<br/>&#169;")
  end
end
