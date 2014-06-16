class BiblesorgApi
  API_KEY = ENV["API_KEY_BIBLESORG"]
  API_URL_TEXT = "https://bibles.org/v2/passages.js"

  LOCALE_TO_VERSION_MAP = {
    :en => "eng-MSG",
    :es => "spa-DHH",
    :"zh-Hans" => "zho-RCUVSS",
  }

  def self.get_version_for_locale
    version = LOCALE_TO_VERSION_MAP[I18n.locale]
    version = LOCALE_TO_VERSION_MAP[I18n.default_locale] if version.nil?
    version
  end

  def self.lookup(bible_ref)
    version = get_version_for_locale
    url = "#{API_URL_TEXT}?version=#{version}&q[]=#{URI::encode(bible_ref)}"
    creds = { :username => API_KEY, :password => "X" }
    response = HTTParty.get(url, :basic_auth => creds)
    response_json = JSON.parse(response.body)
    response_json["response"]["search"]["result"]["passages"][0]
  end

  def self.get_text(bible_ref)
    passage = lookup(bible_ref)
    {
      :text => passage["text"],
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