require_relative "apis/biblesorg_api"
require_relative "apis/crossway_api"
require_relative "apis/net_bible_web_service_api"
require_relative "apis/digital_bible_platform_api"
require_relative "apis/segond_21_osis_file_api"

class Apis
  LOCALE_TO_API_TEXT_MAP = {
    # English
    :"en" => [
      CrosswayApi.new,
      BiblesorgApi.new("eng-CEVD"),
      BiblesorgApi.new("eng-GNTD"),
      NetBibleWebServiceApi.new
    ],
    # Spanish (Latin America)
    :"es-419" => [
      BiblesorgApi.new("spa-DHH")
    ],
    # French
    :"fr" => [
      Segond21OsisFileApi.new("data/bible.fr.segond-21.osis.xml")
    ],
    # Portuguese (Brazil)
    :"pt-BR" => [
      BiblesorgApi.new("por-NTLH")
    ],
    # Chinese Simplified
    :"zh-Hans" => [
      BiblesorgApi.new("zho-RCUVSS")
    ]
  }
  LOCALE_TO_API_AUDIO_MAP = {
    :"en" => [
      CrosswayApi.new,
      nil
    ]
  }

  def self.get_version_count
    locale = I18n.locale
    apis = LOCALE_TO_API_TEXT_MAP.fetch(locale)
    apis.count
  end

  def self.get_text(bible_ref, version: 0)
    locale = I18n.locale
    apis = LOCALE_TO_API_TEXT_MAP.fetch(locale)
    api = apis[version]
    return nil if api.nil?
    get_cache(locale, "#{api.class.name}-#{api.version}").get_or_set("#{bible_ref}_text") do
      puts "Get text for #{bible_ref} from #{api.class.name} (version #{version})"
      api.get_text(bible_ref)
    end
  end

  def self.get_audio(bible_ref, version: 0)
    locale = I18n.locale
    apis = LOCALE_TO_API_AUDIO_MAP[locale]
    return nil if apis.nil?
    api = apis[version]
    return nil if api.nil?
    get_cache(locale, "#{api.class.name}-#{api.version}").get_or_set("#{bible_ref}_audio") do
      api.get_audio(bible_ref)
    end
  end

  def self.get_read_more(bible_ref, version: 0)
    locale = I18n.locale
    apis = LOCALE_TO_API_TEXT_MAP.fetch(locale)
    api = apis[version]
    return nil if api.nil?
    api.get_read_more(bible_ref)
  end

end
