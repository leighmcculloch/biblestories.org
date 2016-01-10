require_relative "apis/biblesorg_api"
require_relative "apis/crossway_api"
require_relative "apis/digital_bible_platform_api"
require_relative "apis/segond_21_osis_file_api"

class Apis
  LOCALE_TO_API_TEXT_MAP = {
      :"en" => [CrosswayApi, BiblesorgApi], # English
      :"zh-Hans" => [BiblesorgApi], # Chinese Simplified
      :"es-419" => [BiblesorgApi], # Spanish (Latin America)
      :"fr" => [Segond21OsisFileApi.new("data/bible.fr.segond-21.osis.xml")], # French
      # :"pt" => [BiblesorgApi], # Portuguese
      :"pt-BR" => [BiblesorgApi], # Portuguese (Brazil)
  }
  LOCALE_TO_API_AUDIO_MAP = {
      :"en" => [CrosswayApi, nil],
      # :"zh-Hans" => [DigitalBiblePlatformApi],
      # :"es-419" => [DigitalBiblePlatformApi],
  }

  def self.get_version_count
    if LOCALE_TO_API_TEXT_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      warn "APIs `get_version_count`: No platform defined for locale #{I18n.locale}"
      return nil
    end
    apis = LOCALE_TO_API_TEXT_MAP[locale]
    apis.count
  end

  def self.get_text(bible_ref, version: 0)
    if LOCALE_TO_API_TEXT_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      warn "APIs `get_text`: No platform defined for locale #{I18n.locale}"
      return nil
    end
    apis = LOCALE_TO_API_TEXT_MAP[locale]
    api = apis[version]
    return nil if api.nil?
    get_cache(locale, api.name).get_or_set("#{locale}_#{api.name}_#{version}_#{bible_ref}_text") do
      puts "Get text for #{bible_ref} from #{api.name} (version #{version})"
      api.get_text(bible_ref)
    end
  end

  def self.get_audio(bible_ref, version: 0)
    if LOCALE_TO_API_AUDIO_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      return nil
    end
    apis = LOCALE_TO_API_TEXT_MAP[locale]
    api = apis[version]
    return nil if api.nil?
    get_cache(locale, api.name).get_or_set("#{locale}_#{api.name}_#{version}_#{bible_ref}_audio") do
      api.get_audio(bible_ref)
    end
  end

  def self.get_read_more(bible_ref, version: 0)
    if LOCALE_TO_API_TEXT_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      locale = I18n.default_locale
    end
    apis = LOCALE_TO_API_TEXT_MAP[locale]
    api = apis[version]
    return nil if api.nil?
    api.get_read_more(bible_ref)
  end

end
