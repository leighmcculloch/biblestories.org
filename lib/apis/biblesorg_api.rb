class BiblesorgApi
  API_KEY = ENV["API_KEY_BIBLESORG"]
  API_URL_TEXT = "https://bibles.org/v2/passages.js"

  LOCALE_TO_VERSION_MAP = {
    :"en" => "eng-MSG", # The Message
    :"es" => "spa-DHH", # 1994 Biblia Dios Habla Hoy (sin notas ni ayudas)
    :"zh-Hans" => "zho-RCUVSS", # 2010 Revised Chinese Union Version
    # :"fr" => "fra-NBS", # 2002 Nouvelle Bible Segond
    :"fr" => "fra-PDV", # 2000 Parole de Vie
    # :"pt" => "por-BPT09",
    # :"pt-BR" => "por-NTLH",
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
    {
      :text => "#{passage["text"]}#{passage["tracking"]}",
      :copyright => passage["copyright"],
      :css => "biblesorg",
    }
  end

  def self.get_audio(bible_ref)
    nil
  end

  def self.get_read_more(bible_ref)
    "http://bibles.org/search/#{bible_ref}/#{get_version_for_locale}"
  end

end