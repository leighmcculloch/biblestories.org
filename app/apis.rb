require_relative "apis/biblesorg_api"
require_relative "apis/crossway_api"
require_relative "apis/digital_bible_platform_api"

class Apis
  LOCALE_TO_API_TEXT_MAP = {
      :en => CrosswayApi,
      :es => BiblesorgApi,
      :zh => BiblesorgApi,
  }
  LOCALE_TO_API_AUDIO_MAP = {
      :en => CrosswayApi,
      :es => DigitalBiblePlatformApi,
      :zh => DigitalBiblePlatformApi,
  }

  def self.get_text(bible_ref)
    api = LOCALE_TO_API_TEXT_MAP[I18n.locale]
    return nil if api.nil?
    $cache.get_or_set("#{I18n.locale}_#{api.class.name}_#{bible_ref}_text") do
      api.get_text(bible_ref)
    end
  end

  def self.get_audio(bible_ref)
    api = LOCALE_TO_API_AUDIO_MAP[I18n.locale]
    return nil if api.nil?
    $cache.get_or_set("#{I18n.locale}_#{api.class.name}_#{bible_ref}_audio") do
      api.get_audio(bible_ref)
    end
  end

  def self.get_read_more(bible_ref)
    api = LOCALE_TO_API_TEXT_MAP[I18n.locale]
    return nil if api.nil?
    $cache.get_or_set("#{I18n.locale}_#{api.class.name}_#{bible_ref}_read_more") do
      api.get_read_more(bible_ref)
    end
  end

end